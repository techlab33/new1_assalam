import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

import '../../data/models/hadith/famous_hadith_data_model.dart';
import '../../data/services/hadith/get_famous_hadith_data.dart';
import '../../controller/language_controller.dart';

class FamousHadithPage extends StatefulWidget {
  const FamousHadithPage({Key? key}) : super(key: key);

  @override
  State<FamousHadithPage> createState() => _FamousHadithPageState();
}

class _FamousHadithPageState extends State<FamousHadithPage> {
  final fetchFamousHadith = GetAllFamousHadith();
  final translator = GoogleTranslator();
  late String targetLanguage;
  late Future<FamousHadithDataModel?> _famousHadithFuture;

  @override
  void initState() {
    super.initState();
    _updateTargetLanguage();
    _famousHadithFuture = fetchFamousHadith.fetchAllFamousHadithData();
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FutureBuilder<FamousHadithDataModel?>(
            future: _famousHadithFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator(color: TColors.primaryColor));
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                final famousHadithDataModel = snapshot.data;
                if (famousHadithDataModel == null || famousHadithDataModel.hadises == null || famousHadithDataModel.hadises!.isEmpty) {
                  return Center(
                    child: Text('No famous hadith data available.'),
                  );
                }
                return Column(
                  children: [
                    for (final hadith in famousHadithDataModel.hadises!)
                      Card(
                        elevation: 3,
                        shadowColor: TColors.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Text(hadith.hadis, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic), textAlign: TextAlign.right),
                              SizedBox(height: 5),
                              FutureBuilder<Translation>(
                                future: translator.translate(hadith.hadisTranslate, from: 'auto', to: targetLanguage),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final translatedText = snapshot.data!.text;
                                    return Text(translatedText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.right);
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<Translation>(
                                future: translator.translate(hadith.hadisDescription, from: 'auto', to: targetLanguage ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final translatedText = snapshot.data!.text;
                                    return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator(color: TColors.primaryColor);
                                  }
                                },
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FutureBuilder<Translation>(
                                  future: translator.translate(hadith.reference, from: 'auto', to: targetLanguage ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final translatedText = snapshot.data!.text;
                                      return Text(translatedText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal), textAlign: TextAlign.left);
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 5),
                              // Row(
                              //   children: [
                              //     IconButton(
                              //       onPressed: ()  {
                              //         String newFavoriteValue = dua.isFavorite == '1' ? '0' : '1'; // Toggle the value
                              //         DuaFevCheckNote().duaFavoriteData(dua.id, newFavoriteValue);
                              //         setState(() {
                              //           hadith.isFavorite = newFavoriteValue; // Update the state with the new value
                              //         });
                              //       },
                              //       icon: Icon(hadith.isFavorite == '1' ? Icons.favorite : Icons.favorite_border , color: hadith.isFavorite == '1' ? Colors.red : Colors.black54, size: 28),
                              //     ),
                              //     // IconButton(
                              //     //   onPressed: () {
                              //     //     String newCheckValue = hadith.isChecked == '1' ? '0' : '1'; // Toggle the value
                              //     //     DuaFevCheckNote().duaCheckData(hadith.id, newCheckValue);
                              //     //     setState(() {
                              //     //       hadith.isChecked = newCheckValue as bool; // Update the state with the new value
                              //     //     });
                              //     //   },
                              //     //   icon: Icon(hadith.isChecked == '1' ? Icons.check_box_outlined : Icons.check_box_outline_blank ,color: hadith.isChecked == '1' ? Colors.green : Colors.black54, size: 28),
                              //     // ),
                              //     // IconButton(
                              //     //   onPressed: () {
                              //     //     showDialog(
                              //     //       context: context,
                              //     //       builder: (context) {
                              //     //         return AlertDialog(
                              //     //           title: Text('Write your notes!', style: TextStyle(fontSize: 16)),
                              //     //           content: Column(
                              //     //             mainAxisSize: MainAxisSize.min,
                              //     //             children: [
                              //     //               TextField(
                              //     //                 controller: noteController,
                              //     //                 decoration: InputDecoration(border: InputBorder.none),
                              //     //                 textInputAction: TextInputAction.newline,
                              //     //                 maxLines: 5,
                              //     //                 autofocus: true,
                              //     //               ),
                              //     //               SizedBox(height: 20),
                              //     //               Row(
                              //     //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     //                 children: [
                              //     //                   TextButton(
                              //     //                     onPressed: () {
                              //     //                       Navigator.of(context).pop();
                              //     //                     },
                              //     //                     child: Text('Cancel', style: TextStyle(fontSize: 16)),
                              //     //                   ),
                              //     //                   TextButton(
                              //     //                     onPressed: () {
                              //     //                       DuaFevCheckNote().duaNoteData(dua.id, noteController.text.toString());
                              //     //                       Navigator.of(context).pop();
                              //     //                       setState(() {});
                              //     //                     },
                              //     //                     child: Text('Save', style: TextStyle(fontSize: 16)),
                              //     //                   ),
                              //     //                 ],
                              //     //               ),
                              //     //             ],
                              //     //           ),
                              //     //         );
                              //     //       },
                              //     //     );
                              //     //   },
                              //     //   // icon: Icon(Icons.edit, color: (dua.note != null && dua.note.isNotEmpty) ? Colors.green : Colors.black54 , size: 28),
                              //     //   icon: Icon(Icons.edit, color: dua.note == "" ? Colors.black54 : Colors.green , size: 28),
                              //     // ),
                              //     IconButton(
                              //       onPressed: () {
                              //         // Share.share('${dua.doa}\n\n${dua.doaTranslate}\n\n${dua.doaDescription}');
                              //       },
                              //       icon: Icon(Icons.share ,color: Colors.black54, size: 28),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
