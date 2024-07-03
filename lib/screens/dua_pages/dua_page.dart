import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/screens/dua_pages/category_page.dart';
import 'package:assalam/screens/dua_pages/my_duas_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dua', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          backgroundColor: TColors.primaryColor,
          bottom: TabBar(
            tabs: [
              Tab(
                child: FutureBuilder<Translation>(
                  future: translator.translate('Category', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText, style: TextStyle(fontSize: 18, color: Colors.white));
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
                  future: translator.translate('My Dua', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText, style: TextStyle(fontSize: 18, color: Colors.white));
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
            DuaCategoryPage(),
            MyDuasPage(),
          ],
        ),
      ),
    );
  }
}
