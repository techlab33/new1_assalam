import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/screens/dua_pages/dua_chack_page.dart';
import 'package:assalam/screens/dua_pages/dua_favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';


class MyDuasPage extends StatefulWidget {
  const MyDuasPage({super.key});

  @override
  State<MyDuasPage> createState() => _MyDuasPageState();
}

class _MyDuasPageState extends State<MyDuasPage> {

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [

              ListTile(
                title: FutureBuilder<Translation>(
                  future: translator.translate('Favorite', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                // title: Text('Favorite', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                leading: Icon(Icons.favorite, color: Colors.red),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                onTap: () => Get.to(DuaFavoritePage()),
              ),
              Divider(color: Colors.green),
              ListTile(
                title: FutureBuilder<Translation>(
                  future: translator.translate('Checkout', from: 'auto', to: targetLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final translatedText = snapshot.data!.text;
                      return Text(translatedText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                // title: Text('Checkout', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                leading: Icon(Icons.check_box_outlined, color: Colors.green,),
                trailing: Icon(Icons.arrow_forward_ios, size: 20,),
                onTap: () => Get.to(DuaCheckPage()),
              ),
              Divider(color: Colors.green),
              // ListTile(
              //   title: Text('Notes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              //   leading: Icon(Icons.edit, color: Colors.green,),
              //   trailing: Icon(Icons.arrow_forward_ios, size: 20,),
              //   onTap: () {
              //
              //   },
              // ),
              // Divider(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
