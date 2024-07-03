import 'dart:io';

import 'package:assalam/controller/image_picker_controller.dart';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/controller/profile/profile_update_controller.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:assalam/utils/helper/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Global key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Profile controller
  final profileController = Get.put(ProfileUpdateController());
  // Image Picker Controller
  final imagePickerController = Get.put(ImagePickerController());

  @override
  void initState() {
    _updateTargetLanguage();
    _getData();
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

  // -------> Function to retrieve data from SharedPreferences <--------

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? userName = prefs.getString(AppConstraints.userName);
      String? userPhone = prefs.getString(AppConstraints.userPhone);
      String? userAddress = prefs.getString(AppConstraints.userAddress);
      String? userImage = prefs.getString(AppConstraints.userImage);

      if (userName != null) {
        profileController.nameController.text = userName;
      }
      if (userPhone != null) {
        profileController.phoneNumberController.text = userPhone;
      }
      if (userAddress != null) {
        profileController.addressController.text = userAddress;
      }
      if (userImage != null) {
        // Convert the image path string to a File
        imagePickerController.image.value = File(userImage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // Screen Size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Edit Profile', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText,
                  style: TextStyle(color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        // title: Text('Edit Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Obx(() =>  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  imagePickerController.imagePickerMethodGallery(ImageSource.gallery);
                                },
                                child: Container(
                                  height: size.height/15.76,
                                  width: size.width/3.27,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.green.shade400),
                                  child: const Center(
                                    child: Text('Gallery', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  imagePickerController.imagePickerMethodGallery(ImageSource.camera);
                                },
                                child: Container(
                                  height: size.height/15.76,
                                  width: size.width/3.27,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.green.shade400),
                                  child: const Center(
                                    child: Text('Camera', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Stack(
                  children: [
                    Container(
                        height: size.height/5.25,
                        width: size.width/2.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                        ),
                        child: imagePickerController.image.value.path == ''
                            ? const Icon(Icons.person_outline, size: 100)
                            : CircleAvatar(backgroundImage: FileImage(imagePickerController.image.value),
                        )),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(Icons.camera_alt_outlined, size: 30),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height/39.4),

              // TExt Field
             Form(
               key: formKey,
               child: Column(
                 children: [
                   TextFormField(
                     controller: profileController.nameController,
                     validator: (value) => TValidator.validateEmptyText('Name', value),
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Name',
                       label: Text('Name'),
                     ),
                   ),
                   //
                   SizedBox(height: 10),
                   TextFormField(
                     controller: profileController.phoneNumberController,
                     validator: (value) => TValidator.validateEmptyText('Phone Number', value),
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Phone Number ',
                       label: Text('Phone Number'),
                     ),
                   ),
                   //
                   SizedBox(height: 10),
                   TextFormField(
                     controller: profileController.addressController,
                     validator: (value) => TValidator.validateEmptyText('Address', value),
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Address ',
                       label: Text('Address'),
                     ),
                   ),

                   SizedBox(height: size.height/19.7),
                   InkWell(
                     onTap: () {
                       if(formKey.currentState!.validate()) {
                         profileController.profileUpdate();
                       }
                     },
                     child: profileController.isLoading.value ? Center(child: CircularProgressIndicator(color: Colors.green)) :   Container(
                       height: size.height/15.32,
                       width: MediaQuery.of(context).size.width,
                       alignment: Alignment.center,
                       decoration: BoxDecoration(
                         color: TColors.primaryColor,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Text('Save', style: const TextStyle(
                         fontSize: 18,
                         color: Colors.white,
                         fontWeight: FontWeight.w500,
                       ),),
                     ),
                   ),
                 ],
               ),
             ),
            ],
          ),
        ),
        ),
      )),
    );
  }
}
