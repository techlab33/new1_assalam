
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import '../../controller/language_controller.dart';
import 'package:assalam/data/models/dua_model/dua_data_model.dart';
import 'package:assalam/data/services/dua/get_all_dua.dart';
import 'package:assalam/screens/dua_pages/morning_evening.dart';
import 'package:assalam/screens/dua_pages/widgets/dua_card_container.dart';
import 'package:assalam/utils/constants/colors.dart';

class DuaCategoryPage extends StatefulWidget {
  const DuaCategoryPage({Key? key});

  @override
  State<DuaCategoryPage> createState() => _DuaCategoryPageState();
}

class _DuaCategoryPageState extends State<DuaCategoryPage> {
  final fetchAllDua = GetAllDua();

  @override
  void initState() {
    _updateTargetLanguage();
    fetchAllDua.fetchAllDuaData();
    super.initState();
  }

  // Language Translator
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
    DuaDataModel? duaDataModel;

    // Screen Size
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              FutureBuilder<DuaDataModel>(
                future: fetchAllDua.fetchAllDuaData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: TColors.primaryColor,);
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    duaDataModel = snapshot.data;
                    return SizedBox(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenSize.width / 45,
                        mainAxisSpacing: screenSize.height / 98.5,
                        shrinkWrap: true,
                        childAspectRatio: 1.15,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final category in duaDataModel!.allCategories ?? [])
                            DuaContainerCard(
                              image: category.image ?? '',
                              title: category.categoryName ?? 'Unknown Category',
                              subtitle: category.totalSubCategories?.toString() ?? '0',
                              color: TColors.primaryColor,
                              onPressed: () => Get.to(MorningAndEveningPage(
                                categoryName: category.categoryName ?? 'Unknown Category',
                                duaDataModel: duaDataModel!,
                                categoryID: category.id?.toString() ?? '',
                              )),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const Text('No data available');
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

