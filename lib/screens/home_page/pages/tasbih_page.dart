import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:vibration/vibration.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});
  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  int _selectedOption = 1; // 0 for no option selected, 1 for option 1

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter = 0;
      _selectedOption = 0; // Reset the selected option
    });
  }

  //===========counting end===============//
  //============audio start==============//

  late AudioPlayer audioPlayer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource('tasbih_sound.mp3'));
    setState(() {
      _isPlaying = true;
    });
  }

  //=================audio end==============//

  final con = FlipCardController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate("Tasbih", from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        // title: Text("Tasbih",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20)),
        backgroundColor: TColors.primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 1,
                  activeColor: Colors.green,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as int;
                    });
                  },
                ),
                Text('07'),
                Radio(
                  value: 2,
                  activeColor: Colors.green,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as int;
                    });
                  },
                ),
                Text('33'),
                Radio(
                  value: 3,
                  activeColor: Colors.green,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as int;
                    });
                  },
                ),
                Text('99'),
              ],
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: screenSize.height / 2.626,
                  width: screenSize.width / 1.285,
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/tasbih.png"),
                ),
                GestureDetector(
                  onTap: () {
                    if (_selectedOption == 1 && _counter == 6) {
                      Vibration.vibrate(duration: 1000);
                    } else if (_selectedOption == 2 && _counter == 32) {
                      Vibration.vibrate(duration: 1000);
                    } else if (_selectedOption == 3 && _counter == 98) {
                      Vibration.vibrate(duration: 1000);
                    }

                    setState(() {
                      _playAudio();
                      _incrementCounter();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 190, left: 120),
                    height: screenSize.height / 10.506,
                    width: screenSize.width / 5.538,
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  height: 30,
                  width: 40,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: screenSize.height / 10.506, left: screenSize.width / 2.8),
                  child: Text(
                    '$_counter',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                GestureDetector(
                  onTap: _decrementCounter,
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.only(top: screenSize.height / 5.083, left: screenSize.width / 1.8461),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),

            //=========== tasbih part end============//
            SizedBox(height: 20),
            Center(
              child: Container(
                height: screenSize.height / 2.626,
                width: MediaQuery.of(context).size.width / 1.1,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [

                      FlipCard(
                        rotateSide: RotateSide.right,
                        disableSplashEffect: false,
                        splashColor: Colors.orange,
                        onTapFlipping: true,
                        axis: FlipAxis.vertical,
                        controller: con,
                        frontWidget: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: screenSize.height / 9.85,
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  "سُبْحَانَ الله",
                                  style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                subtitle: FutureBuilder<Translation>(
                                  future: translator.translate("Subhaana Allah", from: 'auto', to: targetLanguage),
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

                              ),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                "سُبْحَانَ الله",
                                style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<Translation>(
                                future: translator.translate("Anas bin Malik narrated that: Umm Sulaim came upon the Prophet (ﷺ) and said: " "Teach me some words that I can say in my Salat."
                                        "So he said: " "Mention Allah's Greatness (saying: Allahu Akbar) ten times, mention Allah's Glory (saying: Subhan Allah) ten times, "
                                        "and mention Allah's praise (saying: Al-Hamdulilah) ten times. Then ask as you like, (for which) He says: 'Yes. Yes.'", from: 'auto', to: targetLanguage),
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
                            ),
                          ),
                        ),
                      ),
                      //==========//

                      FlipCard(
                        rotateSide: RotateSide.right,
                        disableSplashEffect: false,
                        splashColor: Colors.orange,
                        onTapFlipping: true,
                        axis: FlipAxis.vertical,
                        controller: con,
                        frontWidget: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: screenSize.height / 9.85,
                            child: Card(
                              child: ListTile(
                                title: Text("الْحَمْدُ للهِ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 20,)),
                                subtitle: FutureBuilder<Translation>(
                                  future: translator.translate("Alhamdulillah", from: 'auto', to: targetLanguage),
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
                              ),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height,
                          child: Card(
                            child: ListTile(
                              title: Text("الْحَمْدُ للهِ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 20),),
                              subtitle: FutureBuilder<Translation>(
                                future: translator.translate("On the authority of Abu Malik al-Harith bin Asim al-Ashari (may Allah be pleased with him) who said: The Messenger of Allah (ﷺ) said: " "Purity is half of Iman. Alhamdulillah (praise be to Allah) fills the scales, and subhan-Allah (how far from imperfection is Allah) and Alhamdulillah (praise be to Allah) fill that which is between heaven and earth. And the Salah (prayer) is a light, and charity is a proof, and patience is illumination, and the Quran is a proof either for you or against you. Every person starts his day as a vendor of his soul, either freeing it or bringing about its ruin.", from: 'auto', to: targetLanguage),
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
                            ),
                          ),
                        ),
                      ),
                      //==========//

                      FlipCard(
                        rotateSide: RotateSide.right,
                        disableSplashEffect: false,
                        splashColor: Colors.orange,
                        onTapFlipping: true,
                        axis: FlipAxis.vertical,
                        controller: con,
                        frontWidget: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: screenSize.height / 9.85,
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  "سُبْحَانَ الله",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                               subtitle: FutureBuilder<Translation>(
                                 future: translator.translate("Laa ilaaha illallah", from: 'auto', to: targetLanguage),
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

                              ),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height,
                          child: Card(
                            child: ListTile(
                              title: Text("لَا إِلَهَ إِلَّا اللَّهُ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 20),),
                              subtitle: FutureBuilder<Translation>(
                                future: translator.translate("On the virtue of those who praise Allah (سُبْحَٰنَهُۥ وَتَعَٰلَىٰ). This dhikr also affirms Allah's oneness, a concept known as Tawhid, a central tenet of Islam."
                                    "Jabir bin 'Abdullah said:" "I heard the Messenger of Allah (ﷺ) say: 'The best of remembrance is La ilaha illallah (None has the right to be worshiped but Allah), and the best of supplication is Al-Hamdu Lillah (praise is to Allah). ", from: 'auto', to: targetLanguage),
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

                            ),
                          ),
                        ),
                      ),
                      //==========//

                      FlipCard(
                        rotateSide: RotateSide.right,
                        disableSplashEffect: false,
                        splashColor: Colors.orange,
                        onTapFlipping: true,
                        axis: FlipAxis.vertical,
                        controller: con,
                        frontWidget: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: screenSize.height / 9.85,
                            child: Card(
                              child: ListTile(
                                title: Text("الله أكبر",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 20),),
                                subtitle: FutureBuilder<Translation>(
                                  future: translator.translate("Allahu Akbar", from: 'auto', to: targetLanguage),
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

                              ),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                "الله أكبر",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<Translation>(
                                future: translator.translate("Narrated Jabir bin `Abdullah: Whenever we went up a place we would say, " "Allahu-Akbar (ie Allah is Greater)," "and whenever we went down a place we would say,""Subhan-Allah", from: 'auto', to: targetLanguage),
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

                            ),
                          ),
                        ),
                      ),
                      //==========//

                      FlipCard(
                        rotateSide: RotateSide.right,
                        disableSplashEffect: false,
                        splashColor: Colors.orange,
                        onTapFlipping: true,
                        axis: FlipAxis.vertical,
                        controller: con,
                        frontWidget: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: screenSize.height / 9.85,
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  "أَسْـتَـغْـفِـرُ اللهَ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Astaghfirullah"),
                              ),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                "أَسْـتَـغْـفِـرُ اللهَ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Imam Al-Auza'i (one of the subnarrators) of this Hadith was asked:"
                                  "How forgiveness should be sought?" "He replied:" "I say: Astaghfirullah, Astaghfirullah (I seek forgiveness from Allah. I seek forgiveness from Allah)."),
                            ),
                          ),
                        ),
                      ),
                      //==========//

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}