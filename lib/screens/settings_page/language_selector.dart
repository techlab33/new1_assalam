import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../../controller/language_controller.dart';

class LanguageSelectorPage extends StatefulWidget {


  @override
  State<LanguageSelectorPage> createState() => _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends State<LanguageSelectorPage> {
  final LanguageController languageController = Get.put(LanguageController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Select Language', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        // title: Text('Select Language', style: TextStyle(color: Colors.white)),
        backgroundColor: TColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            buildLanguageCard(context, 'English', 'en'),
            buildLanguageCard(context, 'Arabic', 'ar'),
            buildLanguageCard(context, 'Bengali', 'bn'),
            buildLanguageCard(context, 'Malay (Bahasa Melayu)', 'ms'),
            buildLanguageCard(context, 'Bahasa Indonesia', 'id'),
            buildLanguageCard(context, 'Philippines', 'tl'),
            buildLanguageCard(context, 'Hindi', 'hi'),
            buildLanguageCard(context, 'Thai', 'th'),
            buildLanguageCard(context, 'Cambodia', 'km'),
            // Add more language options as needed
          ],
        ),
      ),
    );
  }

  Widget buildLanguageCard(BuildContext context, String languageName, String languageCode) {
    return Obx(() {
      bool isSelected = languageController.language == languageCode;
      return Card(
        elevation: 3,
        shadowColor: TColors.primaryColor,
        child: ListTile(
          title: Text(languageName, style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            languageController.setLanguage(languageCode);
          },
          trailing: isSelected
              ? Icon(Icons.radio_button_checked, color: Colors.green)
              : Icon(Icons.radio_button_unchecked),
        ),
      );
    });
  }
}
