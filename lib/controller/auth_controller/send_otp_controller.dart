import 'dart:convert';
import 'dart:developer';

import 'package:assalam/screens/authentication/forget_password/otp_screen.dart';
import 'package:assalam/screens/bottom_nav_bar_page/bottom_nav_bar.dart';
import 'package:assalam/utils/constants/api_constants.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendOtpController extends GetxController {
  //
  final TextEditingController forgetEmailController = TextEditingController();


  RxBool isLoading = false.obs;

  // Login
  Future<void> sendOtp() async {
    try {
      // loader
      isLoading.value = true;

      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('https://assalam.icam.com.bd/api/send-otp');

      // body
      Map body = {
        'email': forgetEmailController.text.trim(),
      };

      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {

        final json = jsonDecode(response.body);
        log(response.body);

        // Show Success Message
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['message'] ,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );

        // Navigate Login Screen
        Get.to(const OtpScreen());

        // Clear Text Field
        forgetEmailController.clear();

        // loader
        isLoading.value = false;

      } else {
        throw jsonDecode(response.body)['errors']['email'] ?? 'Unknown Error Occurred';
      }
    } catch (e) {
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
      // loader
      isLoading.value = false;
    }
  }
//
}
