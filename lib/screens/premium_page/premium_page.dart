import 'dart:convert';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/screens/bottom_nav_bar_page/bottom_nav_bar.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/models/premium_model/premium_package_model.dart';
import 'free_package.dart';

class PackageListScreen extends StatefulWidget {
  @override
  _PackageListScreenState createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  late Future<List<Package>> futurePackages;
  static const int userId = 1;

  @override
  void initState() {
    super.initState();
    _updateTargetLanguage();
    futurePackages = fetchPackages();
  }

  // -------> Language Translator <--------
  final translator = GoogleTranslator();
  late String targetLanguage;

  void _updateTargetLanguage() {
    final languageController = Get.put(LanguageController());
    targetLanguage = languageController.language;
    languageController.languageStream.listen((language) {
      setState(() {
        targetLanguage = language;
      });
    });
  }

  // -------> Language Translator <--------

  Future<List<Package>> fetchPackages() async {
    final response = await http
        .get(Uri.parse('https://assalam.icam.com.bd/api/getPackages'));

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body)['Package List'];
      return data.map((json) => Package.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load packages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Subscription AsSalam',
              from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText,
                  style: TextStyle(fontSize: 20, color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        backgroundColor: TColors.primaryColor,
      ),
      body: FutureBuilder<List<Package>>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No packages found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final package = snapshot.data![index];
                return PackageCard(package: package);
              },
            );
          }
        },
      ),
    );
  }
}

//

class PackageCard extends StatefulWidget {
  final Package package;

  PackageCard({required this.package});

  @override
  _PackageCardState createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  double? discountedPrice;
  bool _alertdialog = true;

  Future<double> getDiscountedPrice(String promo, double originalPrice) async {
    try {
      final response = await http.post(
        Uri.parse('https://assalam.icam.com.bd/api/getPrice'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'promo': promo,
          'package_id': widget.package.id,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final discountedPrice = data['Discount Price'] ?? originalPrice;
        // Ensure that the discounted price is a double
        return discountedPrice.toDouble();
      } else {
        Fluttertoast.showToast(
          msg: "Invalid PromoCode",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print(
            'Failed to get discounted price with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return the original price as a double
        return originalPrice;
      }
    } catch (e) {
      print('Exception occurred: $e');
      // Return the original price as a double
      return originalPrice;
    }
  }

  Future<bool> isValidPromoCode(String promoCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://assalam.icam.com.bd/api/checkPromoCode?promo=$promoCode'),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['isValid'];
      } else {
        print(
            'Failed to check promo code validity with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while checking promo code validity: $e');
      return false;
    }
  }

  Future<void> checkAndPurchasePackage(
      int packageId, double originalPrice, String promoCode) async {
    try {
      bool isValidPromo = await isValidPromoCode(promoCode);
      if (!isValidPromo) {
        print('Invalid promo code');
        return;
      }

      double price = await getDiscountedPrice(promoCode, originalPrice);
      setState(() {
        discountedPrice = price;
      });
      purchasePackage(packageId, price, promoCode);
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  Future<void> purchasePackage(
      int packageId, double price, String promo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);
    try {
      final response = await http.post(
        Uri.parse('https://assalam.icam.com.bd/api/makePayment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': id,
          'package_id': packageId,
          'price': price,
          'promo': promo,
        }),
      );

      if (response.statusCode == 201) {
        print('Purchase successful!');
      } else {
        print('Purchase failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  void initState() {
    _updateTargetLanguage();
    super.initState();
  }

  // -------> Language Translator <--------
  final translator = GoogleTranslator();
  late String targetLanguage;

  void _updateTargetLanguage() {
    final languageController = Get.put(LanguageController());
    targetLanguage = languageController.language;
    languageController.languageStream.listen((language) {
      setState(() {
        targetLanguage = language;
      });
    });
  }

  // -------> Language Translator <--------

  //
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double originalPrice = double.tryParse(widget.package.price) ?? 0.0;

    return Card(
      color: TColors.primaryColor,
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () async {
          String? promoCode;
          if (_alertdialog == false) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FreePackage()));
          }
          if (_alertdialog) {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    SizedBox(height: 25),
                    InkWell(
                      onTap: () async {
                        double price = await getDiscountedPrice(promoCode ?? '', originalPrice);
                        setState(() {
                          discountedPrice = price;
                        });
                        await purchasePackage(widget.package.id, price, promoCode ?? '');
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(height: 20),
                                    Image.asset('assets/icons/check.png',
                                      height: 70,
                                      width: 70,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Congratulations!',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green),textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Now you are Assalam Premium Member.',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87), textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 30),
                                    InkWell(
                                      onTap: () {
                                        Get.offAll(BottomNaveBarPage());
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: TColors.primaryColor),
                                        child: Text('OK',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.height,
                          child: WebViewWidget(controller: WebViewController()
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..loadRequest(Uri.parse('https://assalam.icam.com.bd/test'))
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Translation>(
                future: translator.translate(widget.package.name,
                    from: 'auto', to: targetLanguage),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final translatedText = snapshot.data!.text;
                    return Text(translatedText,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
              // Text(widget.package.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,)),
              SizedBox(height: 5.0),
              FutureBuilder<Translation>(
                future: translator.translate(
                    'Price: \$${discountedPrice ?? originalPrice}',
                    from: 'auto',
                    to: targetLanguage),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final translatedText = snapshot.data!.text;
                    return Text(translatedText,
                        style: TextStyle(fontSize: 16, color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
              // Text('Price: \$${discountedPrice ?? originalPrice}'),
              FutureBuilder<Translation>(
                future: translator.translate(
                    'Description: ${widget.package.description}',
                    from: 'auto',
                    to: targetLanguage),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final translatedText = snapshot.data!.text;
                    return Text(translatedText,
                        style: TextStyle(fontSize: 16, color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
              // Text('Description: ${widget.package.description}'),
              SizedBox(height: 5.0),
              FutureBuilder<Translation>(
                future: translator.translate('Features :',
                    from: 'auto', to: targetLanguage),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final translatedText = snapshot.data!.text;
                    return Text(translatedText,
                        style: TextStyle(fontSize: 16, color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
              // Text('Features:'),
              ...widget.package.features.map((feature) {
                return FutureBuilder<Translation>(
                  future: translator.translate('- ${feature.name}',
                      from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText,
                          style: TextStyle(fontSize: 14, color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox();
                    }
                  },
                );
                // return Text('- ${feature.name}');
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
