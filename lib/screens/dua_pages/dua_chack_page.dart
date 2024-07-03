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

class DuaCheckPage extends StatefulWidget {
  const DuaCheckPage({super.key});

  @override
  State<DuaCheckPage> createState() => _DuaCheckPageState();
}

class _DuaCheckPageState extends State<DuaCheckPage> {
  //
  final fetchAllDua = GetAllDua();

  @override
  void initState() {
    _updateTargetLanguage();
    fetchAllDua.fetchAllDuaData();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    //
    DuaDataModel duaDataModel;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('My Checked', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText,  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        // title: Text('My Checked', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              FutureBuilder<DuaDataModel>(
                future: fetchAllDua.fetchAllDuaData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator(color: Colors.green)); // Show a loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    duaDataModel = snapshot.data!;

                    // Check if there are no favorite doas
                    bool hasFavorites = duaDataModel.allCategories!.any((category) =>
                        category.subCategories.any((subcategory) =>
                            subcategory.doas.any((dua) => dua.isChecked == '1')
                        )
                    );
                    if (!hasFavorites) {
                      return Center(child: Text('You have no Checked Data!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: TColors.primaryColor)));
                    }
                    return Column(
                      children: [
                        for (final category in duaDataModel.allCategories!)
                          for (final subcategory in category.subCategories)
                            for (final dua in subcategory.doas)
                              if(dua.isChecked == '1')
                                Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Column(
                                      children: [
                                        Text(dua.doa, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
                                        FutureBuilder<Translation>(
                                          future: translator.translate(dua.doaTranslate!, from: 'auto', to: targetLanguage),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final translatedText = snapshot.data!.text;
                                              return Text(translatedText,  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
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
                                              return Text(translatedText,  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(height: 15),

                                        // Text(dua.doaTranslate, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
                                        // Text(dua.doaDescription, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.check_box_outlined, color: Colors.green, size: 28),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(context: context, builder: (context) {
                                                  return AlertDialog(
                                                    title: Text('Are you sure?'),
                                                    content: Text('Do you want to remove this doa in Check List?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          DuaFevCheckNote().duaCheckData(dua.id!, '0');
                                                          setState(() {});
                                                          log(dua.id.toString());
                                                          log(dua.isChecked.toString());
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },);
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

            ],
          ),
        ),
      ),
    );
  }
}
