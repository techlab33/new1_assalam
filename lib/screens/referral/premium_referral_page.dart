
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/models/reference/reference_data_model.dart';
import 'package:assalam/data/services/claim_reward/claim_premium_reward.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:assalam/data/services/reference/reference_get_data.dart';

import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;


class PremiumReferencePage extends StatefulWidget {
  const PremiumReferencePage({super.key});

  @override
  State<PremiumReferencePage> createState() => _PremiumReferencePageState();
}

class _PremiumReferencePageState extends State<PremiumReferencePage> {

  @override
  void initState() {
    _updateTargetLanguage();
    profileData();
    super.initState();
  }

  final referenceGetData = ReferenceGetData();

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

  final claimRewardData =  ClaimPremiumRewardGetData();

  @override
  Widget build(BuildContext context) {

    // Screen size
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        title: FutureBuilder<Translation>(
          future: translator.translate('Premium Referral', from: 'auto', to: targetLanguage),
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
        // title: Text('Reference'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(239, 229, 223, 1),
              image: DecorationImage(
                image: AssetImage('assets/images/flower-pattern-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // ------>  Left & Right corner image <---------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/left_corner.png'),
                    Image.asset('assets/images/right_corner.png'),
                  ],
                ),
                // -------> assalam logo <--------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/logos/assalam_green-logo.png', height: size.height/7.163, width: size.width/1.8),
                    ),
                  ],
                ),
                // -------->  Premium Refer Card <----------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/18, vertical: size.height/78.8),
                  child: Container(
                    margin: EdgeInsets.only(top: size.height/9.85),
                    padding: EdgeInsets.all(10),
                    height: size.height/8.755,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: TColors.primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            userProfileDataModel?.user!.subPremium == '1' ? FutureBuilder<Translation>(
                              future: translator.translate('You Are Subscribed\nto Premium \n\$5 Package', from: 'auto', to: targetLanguage),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final translatedText = snapshot.data!.text;
                                  return Text(translatedText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox();
                                }
                              },
                            ) : Text('You are not Subscribed\n Premium Package!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap : () {
                                Share.share(userProfileDataModel!.referLinkPremium!);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height/19.7,
                                width: size.width/3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: FutureBuilder<Translation>(
                                  future: translator.translate('Share Your Link', from: 'auto', to: targetLanguage),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final translatedText = snapshot.data!.text;
                                      return Text(translatedText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: TColors.primaryColor),textAlign: TextAlign.center, maxLines: 2,);
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: 5),

                            FutureBuilder<Translation>(
                              future: translator.translate('And get rewards!', from: 'auto', to: targetLanguage),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final translatedText = snapshot.data!.text;
                                  return Text(translatedText, style: TextStyle(fontSize: 12, color: Colors.white));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                            // Text('And get rewards!', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height/78.8),
                // ----->  Claim Reward Button <-----
                Padding(
                  padding: EdgeInsets.only(top: size.height/4.147, left: size.width/12),
                  child: InkWell(
                    onTap: () async {
                      if(userProfileDataModel?.user!.subPremium == '1'){
                        await claimRewardData.ClaimPremiumRewardData();
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: size.height/78.8),
                                Text(claimRewardData.claimPremiumRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              ],
                            ),
                          );
                        },);
                      }else {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: size.height/78.8),
                                Text('This Features only for Premium Member', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              ],
                            ),
                          );
                        },);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height/ 19.7,
                      width: size.width/1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.orange,
                          ],
                        ),
                      ),
                      child: Text('Claim Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height / 3.27, left: size.width/18, right: size.width/18),
                  height: size.height /1.790,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.width/78.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // Share your link text
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Share your link and invite others\n to subscribe to Premium \$10 \npackage and get rewards!',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: size.height/ 52.533),

                        FutureBuilder<ReferenceDataModel>(
                          future: referenceGetData.fetchReferenceData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(margin: EdgeInsets.only(top: size.height/7.88),
                                child: Center(child: CircularProgressIndicator(color: TColors.primaryColor),),
                              );
                            } else if (snapshot.hasError) {
                              print('Error: ${snapshot.error}');
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == null || snapshot.data!.premiumUsers?.userList.isEmpty == true) {
                              return Container(
                                child: Text('You have no reference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                              );
                            } else {
                              final ReferenceDataModel referenceModel = snapshot.data!;
                              final userList = referenceModel.premiumUsers!.userList.toList();

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: userList.length,
                                  itemBuilder: (context, index) {
                                    final user = userList[index];
                                    return ListTile(
                                      title: Text(
                                        user.username,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                                      ),
                                      subtitle: Text(
                                        '(${user.name})\nSubscribed to ${user.subscriptionType} \$${user.price}',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
                                      ),
                                      trailing: Image.asset('assets/icons/check.png', height: size.height / 39.4, width: size.width / 18),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
