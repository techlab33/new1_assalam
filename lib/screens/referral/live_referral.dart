//
// import 'package:assalam/controller/language_controller.dart';
// import 'package:assalam/data/models/profile/user_profile_data_model.dart';
// import 'package:assalam/data/models/reference/reference_data_model.dart';
// import 'package:assalam/data/services/claim_reward/claim_live_svaing_reward.dart';
// import 'package:assalam/data/services/claim_reward/claim_premium_reward.dart';
// import 'package:assalam/data/services/claim_reward/live_assalam_reward.dart';
// import 'package:assalam/data/services/claim_reward/live_cheke_balance_data.dart';
// import 'package:assalam/data/services/profile/get_user_profile_data.dart';
// import 'package:assalam/data/services/reference/reference_get_data.dart';
//
// import 'package:assalam/utils/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:translator/translator.dart';
// import 'package:http/http.dart' as http;
//
//
// class LiveReferralPage extends StatefulWidget {
//   const LiveReferralPage({super.key});
//
//   @override
//   State<LiveReferralPage> createState() => _LiveReferralPageState();
// }
//
// class _LiveReferralPageState extends State<LiveReferralPage> {
//
//   @override
//   void initState() {
//     _updateTargetLanguage();
//     profileData();
//     super.initState();
//   }
//
//   final referenceGetData = ReferenceGetData();
//
//   // -------> Language Translator <--------
//   final translator = GoogleTranslator();
//   late String targetLanguage;
//
//   void _updateTargetLanguage() {
//     final languageController = Get.put(LanguageController());
//     targetLanguage = languageController.language;
//     languageController.languageStream.listen((language) {
//       setState(() {
//         targetLanguage = language;
//       });
//     });
//   }
//
//   // -------> Language Translator <--------
//
//   UserProfileDataModel ? userProfileDataModel;
//   var fetchProfileData = UserProfileGetData();
//   Future<void> profileData() async {
//     try {
//       final fetchedData = await fetchProfileData.fetchUserProfileData();
//       setState(() {
//         userProfileDataModel = fetchedData;
//       });
//     } catch (error) {
//       print("Error fetching Profile Data: $error");
//     }
//   }
//
//   final claimRewardData =  ClaimLiveRewardGetData();
//   final claimLiveSavingRewardData =  ClaimLiveSavingRewardData();
//   final liveBalanceSavingRewardData =  LiveBalanceSavingRewardData();
//
//   @override
//   Widget build(BuildContext context) {
//
//     // Screen size
//     var screenSize = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: TColors.primaryColor,
//         title: FutureBuilder<Translation>(
//           future: translator.translate('Live Referral', from: 'auto', to: targetLanguage),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final translatedText = snapshot.data!.text;
//               return Text(translatedText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white));
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               return SizedBox();
//             }
//           },
//         ),
//         // title: Text('Reference'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             height: screenSize.height,
//             width: screenSize.width,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(239, 229, 223, 1),
//               image: DecorationImage(
//                 image: AssetImage('assets/images/flower-pattern-bg.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // ------>  Left & Right corner image <---------
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset('assets/images/left_corner.png'),
//                     Image.asset('assets/images/right_corner.png'),
//                   ],
//                 ),
//                 // -------> assalam logo <--------
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       alignment: Alignment.center,
//                       child: Image.asset('assets/logos/assalam_green-logo.png', height: 110, width: 200),
//                     ),
//                   ],
//                 ),
//                 // -------->  Premium Refer Card <----------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Container(
//                     margin: EdgeInsets.only(top: 80),
//                     padding: EdgeInsets.all(10),
//                     height: 90,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: TColors.primaryColor,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             userProfileDataModel?.user!.subLive == '1' ? FutureBuilder<Translation>(
//                               future: translator.translate('You Are Subscribed\nto Premium \n\$5 Package', from: 'auto', to: targetLanguage),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   final translatedText = snapshot.data!.text;
//                                   return Text(translatedText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white));
//                                 } else if (snapshot.hasError) {
//                                   return Text('Error: ${snapshot.error}');
//                                 } else {
//                                   return SizedBox();
//                                 }
//                               },
//                             ) : Text('You are not Subscribed\n Live Assalam Package!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
//                           ],
//                         ),
//
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Share.share(userProfileDataModel!.referLinkLive!);
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.all(5),
//                                 height: 45,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.white,
//                                 ),
//                                 child: Text('Share Live Assalam Link',
//                                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: TColors.primaryColor), textAlign: TextAlign.center),
//                               ),
//                             ),
//                             SizedBox(height: 5),
//
//                             FutureBuilder<Translation>(
//                               future: translator.translate('And get rewards!', from: 'auto', to: targetLanguage),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   final translatedText = snapshot.data!.text;
//                                   return Text(translatedText, style: TextStyle(fontSize: 12, color: Colors.white));
//                                 } else if (snapshot.hasError) {
//                                   return Text('Error: ${snapshot.error}');
//                                 } else {
//                                   return SizedBox();
//                                 }
//                               },
//                             ),
//                             // Text('And get rewards!', style: TextStyle(fontSize: 12, color: Colors.white)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//                 // ----->  Claim Reward Button start <-----
//                 Padding(
//                   padding: const EdgeInsets.only(top: 190, left: 30),
//                   child: InkWell(
//                     onTap: () async {
//                       // await claimRewardData.ClaimLiveRewardData();
//                       showDialog(context: context, builder: (context) {
//                         return AlertDialog(
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(height:10),
//                               // Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                                Text('“Are you sure you want to claim your reward now? You could save more if you claim your reward at a higher level”', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                               SizedBox(height:40),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       height: 35,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                           color: TColors.primaryColor
//                                       ),
//                                       child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () async {
//                                       await claimRewardData.ClaimLiveRewardData();
//                                       Navigator.pop(context);
//                                       showDialog(context: context, builder: (context) {
//                                         return AlertDialog(
//                                           content: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                                             ],
//                                           ),
//                                         );
//                                       },);
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       height: 35,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(5),
//                                           color: TColors.primaryColor
//                                       ),
//                                       child: Text('Yes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },);
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 40,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Colors.green,
//                             Colors.orange,
//                           ],
//                         ),
//                       ),
//                       child: Text('Claim Live Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
//                     ),
//                   ),
//                 ),
//                 // Claim Saving Reward
//                 Padding(
//                   padding: const EdgeInsets.only(top: 240, left: 30),
//                   child: InkWell(
//                     onTap: () async {
//                       // await claimRewardData.ClaimRewardData();
//                       showDialog(context: context, builder: (context) {
//                         return AlertDialog(
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(height:10),
//                               // Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                               Text('“Are you sure you want to claim your reward now? You could save more if you claim your reward at a higher level”', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                               SizedBox(height:40),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       height: 35,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(5),
//                                           color: TColors.primaryColor
//                                       ),
//                                       child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () async {
//                                       await claimLiveSavingRewardData.ClaimLiveSavingRewardGetData();
//                                       Navigator.pop(context);
//                                       showDialog(context: context, builder: (context) {
//                                         return AlertDialog(
//                                           content: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(claimLiveSavingRewardData.claimLiveSavingRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                                             ],
//                                           ),
//                                         );
//                                       },);
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       height: 35,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(5),
//                                           color: TColors.primaryColor
//                                       ),
//                                       child: Text('Yes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },);
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 40,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Colors.green,
//                             Colors.orange,
//                           ],
//                         ),
//                       ),
//                       child: Text('Claim Saving Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
//                     ),
//                   ),
//                 ),
//                 //
//                 Padding(
//                   padding: const EdgeInsets.only(top: 290, left: 30),
//                   child: InkWell(
//                     onTap: () async {
//                        await liveBalanceSavingRewardData.LiveBalanceSavingRewardGetData();
//                       showDialog(context: context, builder: (context) {
//                         return AlertDialog(
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(height:10),
//                               Text(liveBalanceSavingRewardData.liveBalanceSavingRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
//                             ],
//                           ),
//                         );
//                       },);
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 40,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Colors.green,
//                             Colors.orange,
//                           ],
//                         ),
//                       ),
//                       child: Text('Check Balance Saving Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
//                     ),
//                   ),
//                 ),
//                 // ----->  Claim Reward Button End<-----
//
//                 Container(
//                   margin: EdgeInsets.only(top: 340, left: 20, right: 20),
//                   height: 440,
//                   width: screenSize.width,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Share your link text
//                         Container(
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Share your link and invite others\n to subscribe to Premium \$10 \npackage and get rewards!',
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(height: 15),
//
//                         FutureBuilder<ReferenceDataModel>(
//                           future: referenceGetData.fetchReferenceData(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return Container(margin: EdgeInsets.only(top: 100),
//                                 child: Center(child: CircularProgressIndicator(color: TColors.primaryColor),),
//                               );
//                             } else if (snapshot.hasError) {
//                               return Text('No data available');
//                               // return Text('Error: ${snapshot.error}');
//                             } else if (snapshot.data == null || snapshot.data!.vipUsers?.userList != true) {
//                               return Container(
//                                 child: Text('You have no References!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
//                               );
//                             } else {
//                               final ReferenceDataModel referenceModel = snapshot.data!;
//                               final userList = referenceModel.premiumUsers!.userList.values.toList();
//
//                               return Expanded(
//                                 child: ListView.builder(
//                                   itemCount: userList.length,
//                                   itemBuilder: (context, index) {
//                                     final user = userList[index];
//
//                                     return ListTile(
//                                       title: Text(
//                                         user.username,
//                                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
//                                       ),
//                                       subtitle: Text(
//                                         '(${user.name ?? ''})\nSubscribed to ${user.subscriptionType ?? ''} \$${user.price ?? ''}',
//                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//                                       ),
//                                       trailing: Image.asset('assets/icons/check.png', height: 20, width: 20),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/models/reference/reference_data_model.dart';
import 'package:assalam/data/services/claim_reward/claim_live_svaing_reward.dart';
import 'package:assalam/data/services/claim_reward/live_assalam_reward.dart';
import 'package:assalam/data/services/claim_reward/live_cheke_balance_data.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:assalam/data/services/reference/reference_get_data.dart';

import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;


class LiveReferralPage extends StatefulWidget {
  const LiveReferralPage({super.key});

  @override
  State<LiveReferralPage> createState() => _LiveReferralPageState();
}

class _LiveReferralPageState extends State<LiveReferralPage> {

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

  final claimRewardData =  ClaimLiveRewardGetData();
  final claimLiveSavingRewardData =  ClaimLiveSavingRewardData();
  final liveBalanceSavingRewardData =  LiveBalanceSavingRewardData();

  @override
  Widget build(BuildContext context) {

    // Screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        title: FutureBuilder<Translation>(
          future: translator.translate('Saving AsSalam', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white));
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
                    height: size.height/8.75,
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
                            userProfileDataModel?.user!.subLive == '1' ? FutureBuilder<Translation>(
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
                            ) : Text('You are not Subscribed\n Live Assalam Package!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Share.share(userProfileDataModel!.referLinkLive!);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                height: size.height/17.51,
                                width: size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Text('Share Your Link', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: TColors.primaryColor), textAlign: TextAlign.center),
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
                // ----->  Claim Reward Button start <-----
                Padding(
                  padding: EdgeInsets.only(top: size.height/4.147, left: size.width/12),
                  child: InkWell(
                    onTap: () async {
                      // await claimRewardData.ClaimLiveRewardData();
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: size.height/78.8),
                              // Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              Text('“Are you sure you want to claim your reward now? You could save more if you claim your reward at a higher level”', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              SizedBox(height: size.height/19.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: size.height/22.514,
                                      width: size.width/4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: TColors.primaryColor
                                      ),
                                      child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await claimRewardData.ClaimLiveRewardData();
                                      Navigator.pop(context);
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                                            ],
                                          ),
                                        );
                                      },);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: size.height/22.514,
                                      width: size.width/4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: TColors.primaryColor
                                      ),
                                      child: Text('Yes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height/19.7,
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
                      child: Text('Claim Live Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                  ),
                ),
                // Claim Saving Reward
                Padding(
                  padding: EdgeInsets.only(top: size.height/3.283, left: size.width/12),
                  child: InkWell(
                    onTap: () async {
                      // await claimRewardData.ClaimRewardData();
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: size.height/78.8),
                              // Text(claimRewardData.claimLiveRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              Text('“Are you sure you want to claim your reward now? You could save more if you claim your reward at a higher level”', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                              SizedBox(height: size.height/19.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: size.height/22.51,
                                      width: size.width / 4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: TColors.primaryColor
                                      ),
                                      child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await claimLiveSavingRewardData.ClaimLiveSavingRewardGetData();
                                      Navigator.pop(context);
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(claimLiveSavingRewardData.claimLiveSavingRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                                            ],
                                          ),
                                        );
                                      },);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: size.height/22.51,
                                      width: size.width / 4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: TColors.primaryColor
                                      ),
                                      child: Text('Yes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },);
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
                      child: Text('Claim Saving Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                  ),
                ),
                //
                Padding(
                  padding: EdgeInsets.only(top: size.height/2.717, left: size.width/12),
                  child: InkWell(
                    onTap: () async {
                      await liveBalanceSavingRewardData.LiveBalanceSavingRewardGetData();
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: size.height/78.8),
                              Text(liveBalanceSavingRewardData.liveBalanceSavingRewardData['message'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: TColors.primaryColor)),
                            ],
                          ),
                        );
                      },);
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
                      child: Text('Check Balance Saving Reward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                  ),
                ),
                // ----->  Claim Reward Button End<-----

                Container(
                  margin: EdgeInsets.only(top: size.height / 2.317, left: size.width/18, right: size.width/18),
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
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == null || snapshot.data!.vipUsers?.userList != true) {
                              return Container(
                                child: Text('You have no References!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
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
                                        '(${user.name ?? ''})\nSubscribed to ${user.subscriptionType ?? ''} \$${user.price ?? ''}',
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
