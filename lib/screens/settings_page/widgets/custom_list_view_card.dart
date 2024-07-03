import 'package:assalam/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class CustomListViewCard extends StatefulWidget {
  CustomListViewCard({
    super.key,
    required this.text,
    required this.image,
    required this.icon,
    required this.onPressed,
  });

  String text;
  String image;
  IconData icon;
  void Function()? onPressed;

  @override
  State<CustomListViewCard> createState() => _CustomListViewCardState();
}

class _CustomListViewCardState extends State<CustomListViewCard> {

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
    return GestureDetector(
      onTap: widget.onPressed,
      child: ListTile(
        title: FutureBuilder<Translation>(
          future: translator.translate(widget.text, from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        leading: Image.asset(widget.image, height: 25, width: 25),
        trailing:  Icon(widget.icon, size: 18),
      ),
    );
  }
}