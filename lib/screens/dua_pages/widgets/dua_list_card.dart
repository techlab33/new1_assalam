import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../../../controller/language_controller.dart';
class DuaListCard extends StatefulWidget {
  DuaListCard({
    super.key,
    required this.number,
    required this.text,
    this.onPressed,
  });

  String number;
  String text;
  void Function()? onPressed;

  @override
  State<DuaListCard> createState() => _DuaListCardState();
}

class _DuaListCardState extends State<DuaListCard> {

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
    return Card(
      elevation: 3,
      shadowColor: TColors.primaryColor,
      child: ListTile(
        onTap: widget.onPressed,
        leading: CircleAvatar(
          radius: 13,
          backgroundColor: TColors.primaryColor,
          child: FutureBuilder<Translation>(
            future: translator.translate('${widget.number}', from: 'auto', to: targetLanguage),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final translatedText = snapshot.data!.text;
                return Text(translatedText, style: TextStyle(fontSize: 14, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return SizedBox();
              }
            },
          ),
          // child: Text(sectionKey, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),

        title: FutureBuilder<Translation>(
          future: translator.translate(widget.text, from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black87));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}