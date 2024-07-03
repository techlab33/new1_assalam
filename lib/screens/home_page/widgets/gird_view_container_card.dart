import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';


class GridViewContainerCard extends StatefulWidget {
  GridViewContainerCard({
    super.key,
    required this.image,
    required this.text,
    this.onPressed,
    this.isPremium = false,
  });

  String image;
  String text;
  bool ? isPremium = false;
  void Function() ? onPressed;

  @override
  State<GridViewContainerCard> createState() => _GridViewContainerCardState();
}

class _GridViewContainerCardState extends State<GridViewContainerCard> {

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
    // Screen Size
    var screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: TColors.primaryColor,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.isPremium! ? Image.asset('assets/icons/premium.png', height: 20, width: 20) : SizedBox(height: 6),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Image.asset(widget.image, height: screenSize.height / 17.51, width: screenSize.width/ 8),
                  const SizedBox(height: 10),

                  FutureBuilder<Translation>(
                    future: translator.translate(widget.text, from: 'auto', to: targetLanguage),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final translatedText = snapshot.data!.text;
                        return Text(translatedText, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.white));
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
          ],
        ),
      ),
    );
  }
}
