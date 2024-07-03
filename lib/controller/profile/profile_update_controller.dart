import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:assalam/screens/bottom_nav_bar_page/bottom_nav_bar.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../image_picker_controller.dart';
import 'package:http/http.dart' as http;

class ProfileUpdateController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  RxBool isLoading = false.obs;
  bool isProfileComplete = true;

  Future<void> profileUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);

    if (userId == null) {
      Fluttertoast.showToast(
        msg: 'User ID not found',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    int id = int.parse(userId);
    final imageController = Get.put(ImagePickerController());
    File? image = imageController.image.value;

    if (image == null) {
      Fluttertoast.showToast(
        msg: 'Please select an image',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      isLoading.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://assalam.icam.com.bd/api/updateProfile/$id'),
      );

      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var length = await image.length();

      var multipartFile = http.MultipartFile('image', stream, length, filename: image.path.split('/').last);

      request.files.add(multipartFile);

      request.fields.addAll({
        "name": nameController.text,
        "mobile": phoneNumberController.text,
        "address": addressController.text,
      });

      log('Request fields: ${request.fields}');
      log('Request files: ${request.files}');

      http.StreamedResponse response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        log('Profile Updated Successfully');

        final json = jsonDecode(responseData.body);
        log('Response data: $json');

        // SharedPreferences
        final SharedPreferences sharedPref = await SharedPreferences.getInstance();
        // is profile complete
        sharedPref.setBool(AppConstraints.isProfileComplete, isProfileComplete);
        sharedPref.setString(AppConstraints.userName, nameController.text);
        sharedPref.setString(AppConstraints.userPhone, phoneNumberController.text);
        sharedPref.setString(AppConstraints.userAddress, addressController.text);
        sharedPref.setString(AppConstraints.userImage, image.path);

        Fluttertoast.showToast(
          msg: 'Profile Updated Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );

        // Navigate to Another Screen
        Get.off(const BottomNaveBarPage());
      } else {
        log('Failed to update profile: ${responseData.body}');
        Fluttertoast.showToast(
          msg: 'Failed to update profile',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      log('Error uploading data and image: $e');
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [
              Text(e.toString()),
            ],
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
