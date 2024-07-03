import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MaccaLivePage extends StatefulWidget {
  MaccaLivePage({Key? key}) : super(key: key);


  @override
  State<MaccaLivePage> createState() => _MaccaLivePageState();
}

class _MaccaLivePageState extends State<MaccaLivePage> {

  String videoUrl = 'https://www.youtube.com/watch?v=moQtMet7F7w';
  YoutubePlayerController ? _youtubePlayerController;

  @override
  void initState() {

    _updateTargetLanguage();

    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: true,
      ),
    );

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
      appBar : AppBar(
        backgroundColor: TColors.primaryColor,
        title: FutureBuilder<Translation>(
          future: translator.translate('Macca Live', from: 'auto', to: targetLanguage),
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

      ),
      body: Center(
        child: ListView(
          children: [

            YoutubePlayer(
              controller: _youtubePlayerController!,
              liveUIColor: Colors.amber,
            ),

          ],
        ),
      ),
    );
  }
}