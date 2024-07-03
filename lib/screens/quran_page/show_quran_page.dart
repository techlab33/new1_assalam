
import 'dart:developer';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/quran_model/quran_data_model.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

class ShowQuranPage extends StatefulWidget {
  ShowQuranPage({
    super.key,
    required this.suraId,
    required this.suraName,
    required this.quranDataModel,
  });

  final String suraName;
  final QuranDataModel quranDataModel;
  final String suraId;

  @override
  State<ShowQuranPage> createState() => _ShowQuranPageState();
}

class _ShowQuranPageState extends State<ShowQuranPage> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  int _currentlyPlayingIndex = -1;
  List<String> _audioQueue = [];

  @override
  void initState() {
    super.initState();
    _updateTargetLanguage();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer();
  }

  // Set Audio Player
  Future<void> _setupAudioPlayer() async {
    _player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _playNextAudio();
      }
    }, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
  }

  Future<void> _playNextAudio() async {
    if (_currentlyPlayingIndex < _audioQueue.length - 1) {
      _currentlyPlayingIndex++;
      await _playAudio(_audioQueue[_currentlyPlayingIndex]);
    } else {
      setState(() {
        _isPlaying = false;
        _currentlyPlayingIndex = -1;
      });
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      await _player.stop();
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      _player.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      log('Error loading audio source: $e');
    }
  }

  void _togglePlayPause(int index) async {
    if (_isPlaying && _currentlyPlayingIndex == index) {
      await _player.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _currentlyPlayingIndex = index;
      await _playAudio(_audioQueue[index]);
    }
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
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    _audioQueue = [
      for (final quran in widget.quranDataModel.data!.surahs)
        for (final ayahs in quran.ayahs.where((element) => quran.number.toString() == widget.suraId))
          ayahs.audio
    ];

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate(widget.suraName, from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (final quran in widget.quranDataModel.data!.surahs)
                for (final ayahs in quran.ayahs.where((element) => quran.number.toString() == widget.suraId))
                  Card(
                    elevation: 3,
                    shadowColor: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height/78.8, bottom: size.height/157.6, left: size.width/36, right: size.width/36),
                      child: Column(
                        children: [
                          Text(
                            ayahs.text,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: size.height/52.53),
                          Text(
                            ayahs.englishTexTranslation,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: size.height/78.8),

                          FutureBuilder<Translation>(
                            future: translator.translate(ayahs.englishTexTranslation, from: 'auto', to: targetLanguage),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final translatedText = snapshot.data!.text;
                                return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          SizedBox(height: size.height/78.8),
                          Row(
                            children: [
                              Text('${widget.suraId}.${ayahs.numberInSurah}'),
                              SizedBox(width: size.width / 4.5),
                              IconButton(
                                icon: Icon(
                                  _currentlyPlayingIndex == _audioQueue.indexOf(ayahs.audio) && _isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 38,
                                ),
                                onPressed: () => _togglePlayPause(_audioQueue.indexOf(ayahs.audio)),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  FlutterClipboard.copy('${ayahs.text}\n${ayahs.englishTexTranslation}');
                                  Get.snackbar(
                                    'Copy!',
                                    '${ayahs.text}\n${ayahs.englishTexTranslation}',
                                    backgroundColor: Colors.green.shade400,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                },
                                icon: Icon(Icons.copy, size: 24),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Share.share('${ayahs.text}\n\n${ayahs.englishTexTranslation}');
                                },
                                icon: Icon(Icons.share, size: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

