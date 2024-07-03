
import 'dart:developer';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/screens/quran_page/show_quran_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:assalam/data/models/quran_model/quran_data_model.dart';
import 'package:assalam/data/services/quran/quran_all_data.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {

  @override
  void initState() {
    _updateTargetLanguage();
    super.initState();
  }

  final fetchAllQuran = GetAllQuran();

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
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Al-Quran', from: 'auto', to: targetLanguage),
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
        child: FutureBuilder<QuranDataModel>(
          future: fetchAllQuran.fetchAllQuranData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: TColors.primaryColor));
            } else if (snapshot.hasError) {
              log('Error: ${snapshot.error}');
              return Center(
                child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
              ); // Error handling with a user-friendly message
            } else if (snapshot.hasData) {
              final quranDataModel = snapshot.data; // This could be null, so be cautious
              final surahs = quranDataModel?.data?.surahs ?? []; // Default to empty list
              if (surahs.isEmpty) {
                return Center(
                  child: Text('No Data found'), // Handling the case when there's no data
                );
              }

              return ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final quran = surahs[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.green,
                      child: ListTile(
                        onTap: () => Get.to(ShowQuranPage(
                                  suraId: quran.number.toString(),
                                  suraName: quran.englishName,
                                  quranDataModel: quranDataModel!,
                                )),
                        leading: CircleAvatar(
                          radius: 13,
                          backgroundColor: TColors.primaryColor,
                          child: Text(quran.number.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        title: Text(quran.englishName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        subtitle: FutureBuilder<Translation>(
                          future: translator.translate('Ayat : ${quran.ayahs.length.toString()}', from: 'auto', to: targetLanguage),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final translatedText = snapshot.data!.text;
                              return Text(translatedText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                         trailing: Text(quran.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("No data available")); // Default message for no data
            }
          },
        ),
      ),
    );
  }
}

