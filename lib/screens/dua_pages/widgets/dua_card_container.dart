import 'package:assalam/controller/language_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class DuaContainerCard extends StatefulWidget {
  DuaContainerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
    this.onPressed,
  });

  String title;
  String subtitle;
  Color color;
  String image;
  void Function()? onPressed;

  @override
  State<DuaContainerCard> createState() => _DuaContainerCardState();
}

class _DuaContainerCardState extends State<DuaContainerCard> {

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
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            CachedNetworkImage(
              imageUrl: widget.image ?? '',
              height: 45,
              width: 45,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 10),
            FutureBuilder<Translation>(
              future: translator.translate(widget.title, from: 'auto', to: targetLanguage),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final translatedText = snapshot.data!.text;
                  return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox();
                }
              },
            ),
            //SizedBox(height: 5),
            FutureBuilder<Translation>(
              future: translator.translate('${widget.subtitle} Chapters', from: 'auto', to: targetLanguage),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final translatedText = snapshot.data!.text;
                  return Text(translatedText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white70));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

