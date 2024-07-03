import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';

import 'package:assalam/screens/dua_pages/dua_page.dart';
import 'package:assalam/screens/hadith_page/hadith_page.dart';
import 'package:assalam/screens/home_page/pages/qiblah_page.dart';
import 'package:assalam/screens/home_page/pages/tasbih_page.dart';
import 'package:assalam/screens/home_page/widgets/PremiumAlertDialogShow.dart';
import 'package:assalam/screens/home_page/widgets/gird_view_container_card.dart';
import 'package:assalam/screens/jakat_page/jakat_page.dart';
import 'package:assalam/screens/live_stream/live_stream.dart';
import 'package:assalam/screens/live_stream/macca_live.dart';
import 'package:assalam/screens/live_stream/medina_live.dart';
import 'package:assalam/screens/premium_content_page/premium_content_page.dart';
import 'package:assalam/screens/qiblah_page/qiblah_page.dart';
import 'package:assalam/screens/quran_page/quran_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {

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

  // --------> User Profile Data <--------
  var fetchProfileData = UserProfileGetData();
  // --------> User Profile Data Get <--------

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Assalam All Items', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText,
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),
                  maxLines: 1, overflow: TextOverflow.ellipsis);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        // title: Text('Assalam All Items', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20)),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                const SizedBox(height: 10),
                FutureBuilder<UserProfileDataModel>(
                  future: fetchProfileData.fetchUserProfileData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(margin: EdgeInsets.only(top: 200),child: Center(child: CircularProgressIndicator(color: Colors.green)));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data?.user == null) {
                      return Text('No data available');
                    } else {
                      final UserProfileDataModel userProfileDataModel = snapshot.data!;
                      return SizedBox(
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: screenSize.width / 45,
                          mainAxisSpacing: screenSize.height / 98.5,
                          shrinkWrap: true,
                          childAspectRatio: 1,
                          physics:const NeverScrollableScrollPhysics(),
                          children: [
                            GridViewContainerCard(
                              image: 'assets/icons/tasbih.png',
                              text: 'Tasbih',
                              onPressed: () => Get.to(TasbihPage()),
                            ),
                            GridViewContainerCard(
                              image: 'assets/images/quran-icon.png',
                              text: 'Al-Quran',
                              onPressed: () => Get.to(QuranPage()),
                            ),
                            GridViewContainerCard(
                              image: 'assets/images/hadith-book-icon.png',
                              text: 'Hadith',
                              onPressed: () => Get.to(HadithPage()),
                            ),
                            GridViewContainerCard(
                              image: 'assets/icons/pray.png',
                              text: 'Dua',
                              onPressed: () => Get.to(DuaPage()),
                            ),
                            GridViewContainerCard(
                              image: 'assets/icons/calculator.png',
                              text: 'Zakat',
                              onPressed: () => Get.to(ZakatCalculatorPage(), duration: Duration(milliseconds: 600)),
                            ),
                            GridViewContainerCard(
                              image: 'assets/icons/kaaba.png',
                              text: 'Qiblah',
                              onPressed: () => Get.to(QiblaPage(), duration: Duration(milliseconds: 600)),
                            ),
                            GridViewContainerCard(
                              image: 'assets/images/live-mecca-icon.png',
                              text: 'Live Mecca',
                              onPressed: () => Get.to(MaccaLivePage(), duration: Duration(milliseconds: 600)),
                            ),
                            GridViewContainerCard(
                              image: 'assets/images/live-medina-icon.png',
                              text: 'Live Medina',
                              onPressed: () => Get.to(MedinaLivePage(), duration: Duration(milliseconds: 600)),
                            ),
                            GridViewContainerCard(
                              isPremium: true,
                              image: 'assets/images/live-assalam-icon.png',
                              text: 'Live Assalam',
                              onPressed: () {
                                userProfileDataModel.user?.subscriptionType == null ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PremiumAlertDialogShow(screenSize: screenSize);
                                    }) : Get.to(LiveStreamPage());
                              },
                            ),
                            GridViewContainerCard(
                              isPremium: true,
                              image: 'assets/logos/logo_assalam_hijau.png',
                              text: 'Education',
                              onPressed: () {
                                userProfileDataModel.user?.subscriptionType == null ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PremiumAlertDialogShow(screenSize: screenSize);
                                    }) : Get.to(PremiumContentPage());
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                // Grid view

              ],
            ),
          ),
        ),
      ),
    );
  }
}
