
import 'package:assalam/screens/hadith_page/all_hadith_page.dart';
import 'package:assalam/screens/hadith_page/famous_hadith_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../../controller/language_controller.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {

  final translator = GoogleTranslator();
  late String targetLanguage;

  @override
  void initState() {
    _updateTargetLanguage();
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title :  FutureBuilder<Translation>(
            future: translator.translate('Hadith', from: 'auto', to: targetLanguage),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final translatedText = snapshot.data!.text;
                return Text(translatedText, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return SizedBox();
              }
            },
          ),
          // title: Text('Hadith', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          backgroundColor: TColors.primaryColor,
          bottom: TabBar(
            tabs: [
              Tab(
                child: FutureBuilder<Translation>(
                  future: translator.translate('All Hadith', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText,style: TextStyle(fontSize: 16, color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              Tab(
                child: FutureBuilder<Translation>(
                  future: translator.translate('Famous Hadith', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText,style: TextStyle(fontSize: 16, color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllHadithPage(),
            FamousHadithPage(),
          ],
        ),
      ),
    );
  }
}
