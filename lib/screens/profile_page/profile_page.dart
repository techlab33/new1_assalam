
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:assalam/screens/profile_page/edit_profile.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data Function
  var fetchProfileData = UserProfileGetData();

  @override
  void initState() {
    _updateTargetLanguage();
    fetchProfileData.fetchUserProfileData();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('User Profile',
              from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText,
                  style: TextStyle(color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        backgroundColor: TColors.primaryColor,
        actions: [
          InkWell(
            onTap: () => Get.to(EditProfilePage()),
            child: Image.asset('assets/icons/edit-profile.png', height: size.height/19.7, width: size.width/9),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<UserProfileDataModel>(
            future: fetchProfileData.fetchUserProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.only(top: size.height/3.94),
                  child: Center(child: CircularProgressIndicator(color: TColors.primaryColor)),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data?.user == null) {
                return Text('No data available');
              } else {
                final UserProfileDataModel userProfileDataModel = snapshot.data!;

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width/24, vertical: size.height/52.53),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          // Profile Image
                          Container(
                            alignment: Alignment.center,
                            height: size.height/6.56,
                            width: size.width/3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: TColors.primaryColor,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: size.height/5.25,
                              width: size.width/3.13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.green,
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: userProfileDataModel.user?.image ?? '',
                                  height: size.height/5.25,
                                  width: size.width/3.13,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height/39.4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green)),
                                  Divider(color: Colors.green),
                                ],
                              ),
                              SizedBox(height: size.height/78.8),
                              // User Name
                              Text("Name : ${userProfileDataModel.user?.name ?? 'No Name'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              SizedBox(height: size.height/78.8),
                              // User Name
                              Text("Username : ${userProfileDataModel.user?.username ?? 'No Name'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              SizedBox(height: size.height/78.8),
                              // User Email
                              Text("Email : ${userProfileDataModel.user?.email ?? 'No Email'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              SizedBox(height: size.height/78.8),
                              Text("Phone : ${userProfileDataModel.user?.mobile ?? 'No Mobile'}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                              Text("Address : ${userProfileDataModel.user?.address ?? 'No Address'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: size.height/39.4),
                              Row(
                                children: [
                                  Text('Subscription Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green)),
                                  Divider(color: Colors.green),
                                ],
                              ),
                              SizedBox(height: size.height/78.8),
                              // User Balance
                              Text(
                                'Balance : \$ ${userProfileDataModel.user?.balance ?? '0'}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              SizedBox(height: size.height/78.8),
                              Text(
                                "Bank Name : ${userProfileDataModel.user?.bankName ?? 'Not Bank'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: size.height/78.8),
                              Text(
                                "Bank Ac. No. : ${userProfileDataModel.user?.bankAccountNumber ?? 'Not Bank'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: size.height/78.8),

                              // Loop through Subscription Types
                              Text(
                                "Subscription Types:",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              ...userProfileDataModel.user!.subscriptionType!.map((subscription) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Subscription Type: ${subscription.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    Text("Subscription Start Date: ${userProfileDataModel.user!.subPremiumStart}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    Text("SubscriptionEnd Date: ${userProfileDataModel.user!.subPremiumEnd}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    SizedBox(height: size.height/78.8),
                                  ],
                                );
                              }).toList(),

                              SizedBox(height: size.height/39.4),
                              Row(
                                children: [
                                  Text('Referral Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green)),
                                  Divider(color: Colors.green),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Referral Id : ${userProfileDataModel.user?.referId ?? 'No Referral ID'}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.info_outline, color: Colors.red),
                                  ),
                                ],
                              ),
                              // Referral Link
                              Text(
                                "Referral Link : ${userProfileDataModel.user?.referLink ?? 'No Referral Link'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: size.height/78.8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
