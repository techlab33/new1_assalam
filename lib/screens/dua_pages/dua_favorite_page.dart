import 'dart:developer';

import 'package:assalam/data/models/dua_model/dua_data_model.dart';
import 'package:assalam/data/services/dua/dua_fev_check_note_data.dart';
import 'package:assalam/data/services/dua/get_all_dua.dart';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';


class DuaFavoritePage extends StatefulWidget {
  const DuaFavoritePage({super.key});

  @override
  State<DuaFavoritePage> createState() => _DuaFavoritePageState();
}

class _DuaFavoritePageState extends State<DuaFavoritePage> {
  //
  final translator = GoogleTranslator();
  late String targetLanguage;

  final fetchAllDua = GetAllDua();

  @override
  void initState() {
    _updateTargetLanguage();
    fetchAllDua.fetchAllDuaData();
    super.initState();
  }

  void _updateTargetLanguage() {
    final languageController = Get.put(LanguageController());
    targetLanguage = languageController.language;
    languageController.languageStream.listen((language) {
      setState(() {
        targetLanguage = language;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    DuaDataModel duaDataModel;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('My Favorite', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),

        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
            FutureBuilder<DuaDataModel>(
            future: fetchAllDua.fetchAllDuaData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.green)); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              }  else {
                duaDataModel = snapshot.data!;

                // Check if there are no favorite doas
                bool hasFavorites = duaDataModel.allCategories!.any((category) =>
                    category.subCategories.any((subcategory) =>
                        subcategory.doas.any((dua) => dua.isFavorite == '1')
                    )
                );
                if (!hasFavorites) {
                  return Center(child: Text('You have no Favorite Data!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: TColors.primaryColor)));
                }

                return Column(
                  children: [
                    for (final category in duaDataModel.allCategories!)
                      for (final subcategory in category.subCategories)
                        for (final dua in subcategory.doas)
                          if (dua.isFavorite == '1')
                            Card(
                              elevation: 3,
                              shadowColor: TColors.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Column(
                                  children: [
                                    Text(dua.doa, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
                                    FutureBuilder<Translation>(
                                      future: translator.translate(dua.doaTranslate, from: 'auto', to: targetLanguage),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final translatedText = snapshot.data!.text;
                                          return Text(translatedText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    FutureBuilder<Translation>(
                                      future: translator.translate(dua.doaDescription, from: 'auto', to: targetLanguage),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final translatedText = snapshot.data!.text;
                                          return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(dua.isFavorite == '1' ? Icons.favorite : Icons.favorite_border, color: dua.isFavorite == '1' ? Colors.red : Colors.black54, size: 28),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(
                                                title: FutureBuilder<Translation>(
                                                  future: translator.translate('Are you sure?', from: 'auto', to: targetLanguage),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final translatedText = snapshot.data!.text;
                                                      return Text(translatedText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
                                                    } else if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  },
                                                ),
                                                content: FutureBuilder<Translation>(
                                                  future: translator.translate('Do you want to remove this doa from your Favorite List?', from: 'auto', to: targetLanguage),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final translatedText = snapshot.data!.text;
                                                      return Text(translatedText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
                                                    } else if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      DuaFevCheckNote().duaFavoriteData(dua.id!, '0');
                                                      setState(() {});
                                                      log(dua.id.toString());
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 70,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: Text('Delete', style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    SizedBox(height: 2),
                  ],
                );
              }
            },
          ),

          // FutureBuilder<DuaDataModel>(
              //   future: fetchAllDua.fetchAllDuaData(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: const CircularProgressIndicator(color: Colors.green)); // Show a loading indicator while fetching data
              //     } else if (snapshot.hasError) {
              //       print(snapshot.error);
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       duaDataModel = snapshot.data!;
              //
              //       return Column(
              //         children: [
              //
              //           for (final category in duaDataModel.allCategories!)
              //             for (final subcategory in category.subCategories)
              //               for (final dua in subcategory.doas)
              //                 if(dua.isFavorite == '1')
              //                   Card(
              //                     elevation: 3,
              //                     child: Padding(
              //                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              //                       child: Column(
              //                         children: [
              //                           Text(dua.doa, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
              //                           FutureBuilder<Translation>(
              //                             future: translator.translate(dua.doaTranslate, from: 'auto', to: targetLanguage),
              //                             builder: (context, snapshot) {
              //                               if (snapshot.hasData) {
              //                                 final translatedText = snapshot.data!.text;
              //                                 return Text(translatedText,  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
              //                               } else if (snapshot.hasError) {
              //                                 return Text('Error: ${snapshot.error}');
              //                               } else {
              //                                 return SizedBox();
              //                               }
              //                             },
              //                           ),
              //                           SizedBox(height: 10),
              //                           FutureBuilder<Translation>(
              //                             future: translator.translate(dua.doaDescription, from: 'auto', to: targetLanguage),
              //                             builder: (context, snapshot) {
              //                               if (snapshot.hasData) {
              //                                 final translatedText = snapshot.data!.text;
              //                                 return Text(translatedText,  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
              //                               } else if (snapshot.hasError) {
              //                                 return Text('Error: ${snapshot.error}');
              //                               } else {
              //                                 return SizedBox();
              //                               }
              //                             },
              //                           ),
              //                           SizedBox(height: 10),
              //                           Row(
              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               Icon(dua.isFavorite == '1' ? Icons.favorite : Icons.favorite_border , color: dua.isFavorite == '1' ? Colors.red : Colors.black54, size: 28),
              //                               GestureDetector(
              //                                 onTap: () {
              //                                   showDialog(context: context, builder: (context) {
              //                                     return AlertDialog(
              //                                       title: FutureBuilder<Translation>(
              //                                         future: translator.translate('Are you sure?', from: 'auto', to: targetLanguage),
              //                                         builder: (context, snapshot) {
              //                                           if (snapshot.hasData) {
              //                                             final translatedText = snapshot.data!.text;
              //                                             return Text(translatedText,  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
              //                                           } else if (snapshot.hasError) {
              //                                             return Text('Error: ${snapshot.error}');
              //                                           } else {
              //                                             return SizedBox();
              //                                           }
              //                                         },
              //                                       ),
              //                                       content: FutureBuilder<Translation>(
              //                                         future: translator.translate('Do you want to remove this doa in Favorite List?', from: 'auto', to: targetLanguage),
              //                                         builder: (context, snapshot) {
              //                                           if (snapshot.hasData) {
              //                                             final translatedText = snapshot.data!.text;
              //                                             return Text(translatedText,  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
              //                                           } else if (snapshot.hasError) {
              //                                             return Text('Error: ${snapshot.error}');
              //                                           } else {
              //                                             return SizedBox();
              //                                           }
              //                                         },
              //                                       ),
              //                                       actions: [
              //                                         TextButton(
              //                                           onPressed: () {
              //                                             Navigator.of(context).pop();
              //                                           },
              //                                           child: Text('No'),
              //                                         ),
              //                                         TextButton(
              //                                           onPressed: () {
              //                                             DuaFevCheckNote().duaFavoriteData(dua.id!, '0');
              //                                             setState(() {});
              //                                             log(dua.id.toString());
              //                                             Navigator.of(context).pop();
              //                                           },
              //                                           child: Text('Yes'),
              //                                         ),
              //                                       ],
              //                                     );
              //                                   },);
              //                                 },
              //                                 child: Container(
              //                                   height: 25,
              //                                   width: 70,
              //                                   alignment: Alignment.center,
              //                                   decoration: BoxDecoration(
              //                                     color: Colors.green,
              //                                     borderRadius: BorderRadius.circular(100)
              //                                   ),
              //                                   child: Text('Delete', style: TextStyle(color: Colors.white)),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(height: 2),
              //         ],
              //       );
              //     }
              //   },
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
