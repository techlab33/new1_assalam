import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:assalam/screens/authentication/log_in_page/login_page.dart';
import 'package:assalam/screens/home_page/pages/more_page.dart';
import 'package:assalam/screens/premium_page/premium_page.dart';
import 'package:assalam/screens/profile_page/edit_profile.dart';
import 'package:assalam/screens/profile_page/profile_page.dart';
import 'package:assalam/screens/referral/live_referral.dart';
import 'package:assalam/screens/referral/vip_premium_referral_page.dart';
import 'package:assalam/screens/settings_page/language_selector.dart';
import 'package:assalam/screens/settings_page/notification_page.dart';
import 'package:assalam/screens/referral/premium_referral_page.dart';
import 'package:assalam/screens/settings_page/widgets/custom_list_view_card.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // var fetchProfileData = UserProfileGetData();

  @override
  void initState() {
    _updateTargetLanguage();
    profileData();
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

  UserProfileDataModel ? userProfileDataModel;
  var fetchProfileData = UserProfileGetData();
  Future<void> profileData() async {
    try {
      final fetchedData = await fetchProfileData.fetchUserProfileData();
      setState(() {
        userProfileDataModel = fetchedData;
      });
    } catch (error) {
      print("Error fetching Profile Data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        title: FutureBuilder<Translation>(
          future: translator.translate('Settings', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),

      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile
                CustomListViewCard(
                  text: 'User Profile',
                  image: 'assets/icons/user.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () async {
                    final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    final bool? isProfileComplete =
                    prefs.getBool(AppConstraints.isProfileComplete);
                    Get.to(isProfileComplete == true
                        ? ProfilePage()
                        : EditProfilePage());
                  },
                ),
                // Premium
                CustomListViewCard(
                  text: 'Subscribe',
                  image: 'assets/icons/premium.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => Get.to(PackageListScreen()),
                ),
                // Premium Reference
                CustomListViewCard(
                  text: 'Premium Referral',
                  image: 'assets/icons/reference.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => Get.to(PremiumReferencePage()),
                ),
                // VIP Premium Reference
                CustomListViewCard(
                  text: 'Vip Premium Referral',
                  image: 'assets/icons/reference.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => Get.to(VipPremiumReferencePage()),
                ),
                // Live Reference
                CustomListViewCard(
                  text: 'Saving AsSalam',
                  image: 'assets/icons/reference.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => Get.to(LiveReferralPage()),
                ),
                // Premium
                CustomListViewCard(
                  text: 'All Items',
                  image: 'assets/icons/menu.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => Get.to(MorePage()),
                ),
                // Notification
                CustomListViewCard(
                  text: 'Notification',
                  image: 'assets/icons/notification.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    Get.to(NotificationSettingsPage());
                  },
                ),
                // Languages
                CustomListViewCard(
                  text: 'Languages',
                  image: 'assets/icons/language.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelectorPage()));
                  },
                ),

                // Share
                CustomListViewCard(
                  text: 'Share',
                  image: 'assets/icons/share.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    // Share.share(shareUrl!);
                    Share.share(userProfileDataModel?.playstoreLink ?? '');
                  },
                ),
                // Share
                // CustomListViewCard(
                //   text: 'Open App',
                //   image: 'assets/icons/share.png',
                //   icon: Icons.arrow_forward_ios,
                //   onPressed: () {
                //     Get.to(ClickOpenApp());
                //   },
                // ),
                // Logout
                CustomListViewCard(
                  text: 'Logout',
                  image: 'assets/icons/logout.png',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: FutureBuilder<Translation>(
                            future: translator.translate('Do you want to Logout?', from: 'auto', to: targetLanguage),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final translatedText = snapshot.data!.text;
                                return Text(translatedText,
                                    style: TextStyle(fontFamily: 'Open_Sans', fontSize: 20, fontWeight: FontWeight.w500));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: FutureBuilder<Translation>(
                                    future: translator.translate('Cancel', from: 'auto', to: targetLanguage),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final translatedText = snapshot.data!.text;
                                        return Text(translatedText,
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500));
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    logout();
                                  },
                                  child: FutureBuilder<Translation>(
                                    future: translator.translate('Yes', from: 'auto', to: targetLanguage),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final translatedText =
                                            snapshot.data!.text;
                                        return Text(translatedText,
                                            style: TextStyle(fontSize: 17, fontWeight:
                                            FontWeight.w500));
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
        // child: FutureBuilder<UserProfileDataModel>(
        //     future: fetchProfileData.fetchUserProfileData(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Container(
        //             margin: EdgeInsets.only(top: 200),
        //             child: Center(child: CircularProgressIndicator(color: TColors.primaryColor)));
        //       } else if (snapshot.hasError) {
        //         return Text('Error: ${snapshot.error}');
        //       } else if (snapshot.data == null || snapshot.data?.user == null) {
        //         return Text('No data available');
        //       } else {
        //         final UserProfileDataModel userProfileDataModel = snapshot.data!;
        //         String? shareUrl = userProfileDataModel.playstoreLink;
        //
        //         return ;
        //       }
        //     }),
      )),
    );
  }

  // Logout
  void logout() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    // Clear user all data
    sharedPref.clear();

    // Navigate back to the login screen
    Get.offAll(const LoginScreen());
  }
}
