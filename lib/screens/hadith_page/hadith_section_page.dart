import 'package:assalam/screens/hadith_page/all_hadith_show_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:assalam/data/services/hadith/get_hadith_book_data.dart';
import 'package:assalam/data/models/hadith/hadith_book_data_model.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../../controller/language_controller.dart';

class HadithSectionPage extends StatefulWidget {
  final int hadithId;
  final String hadithName;
  final String hadithApi;

  const HadithSectionPage({
    Key? key,
    required this.hadithId,
    required this.hadithName,
    required this.hadithApi,
  }) : super(key: key);

  @override
  State<HadithSectionPage> createState() => _HadithSectionPageState();
}

class _HadithSectionPageState extends State<HadithSectionPage> {
  final fetchHadithBookData = GetHadithBookData();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        title: FutureBuilder<Translation>(
          future: translator.translate(widget.hadithName, from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<HadithBookDataModel>(
          future: fetchHadithBookData.fetchHadithBookData(widget.hadithApi),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: TColors.primaryColor,));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final hadithBookDataModel = snapshot.data!;

              if (hadithBookDataModel.metadata != null) {
                final sections = hadithBookDataModel.metadata!.sections;
                final sectionDetails = hadithBookDataModel.metadata!.sectionDetails;

                return ListView.builder(
                  itemCount: sections.length > 1 ? sections.length - 1 : 0,
                  itemBuilder: (context, index) {
                    final sectionKey = sections.keys.elementAt(index + 1);
                    final sectionName = sections[sectionKey] ?? 'Unknown Section';
                    final sectionDetail = sectionDetails[sectionKey];

                    if (sectionDetail != null) {
                      final hadithFirstNumber = sectionDetail.hadithnumberFirst ?? 0;
                      final hadithLastNumber = sectionDetail.hadithnumberLast ?? 0;

                      return Card(
                        elevation: 3,
                        shadowColor: TColors.primaryColor,
                        child: ListTile(
                          title: FutureBuilder<Translation>(
                            future: translator.translate(sectionName, from: 'auto', to: targetLanguage),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final translatedText = snapshot.data!.text;
                                return Text(translatedText, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16), maxLines: 3, overflow: TextOverflow.ellipsis);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          leading: CircleAvatar(
                            radius: 13,
                            backgroundColor: TColors.primaryColor,
                            child: Text(sectionKey, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),

                          trailing: FutureBuilder<Translation>(
                            future: translator.translate('$hadithFirstNumber - $hadithLastNumber', from: 'auto', to: targetLanguage),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final translatedText = snapshot.data!.text;
                                return Text(translatedText,  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          onTap: () => Get.to(AllHadithShowPage(
                            sectionName: sectionName,
                            hadithBookDataModel: hadithBookDataModel,
                            sectionKey: sectionKey,
                            hadithFirstNumber: hadithFirstNumber,
                            hadithLastNumber: hadithLastNumber,
                          )),
                        ),
                      );
                    } else {
                      return const SizedBox(); // Return an empty widget if sectionDetail is null
                    }
                  },
                );

              } else {
                return const Center(child: Text("No metadata available!"));
              }
            } else {
              return const Center(child: Text("No data available!"));
            }
          },
        ),
      ),
    );
  }
}
