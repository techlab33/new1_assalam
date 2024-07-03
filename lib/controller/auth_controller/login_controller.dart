import 'dart:convert';
import 'dart:developer';

import 'package:assalam/screens/bottom_nav_bar_page/bottom_nav_bar.dart';
import 'package:assalam/utils/constants/api_constants.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  //
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  RxBool isLoading = false.obs;
  RxBool userLogin = true.obs;

  // Login
  Future<void> login() async {
    try {
      // loader
      isLoading.value = true;

      var headers = {'Content-Type': 'application/json'};
       var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
     //  var url = Uri.parse('https://assalam.icam.com.bd/api/login');
      // body
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      };

      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {

        final json = jsonDecode(response.body);
        log(response.body);

        int userId = json["user"]["id"];
        String userName = json["user"]["name"];
        String userEmail = json["user"]["email"];

        // Shared Preferences Save User Data
        final SharedPreferences sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString(AppConstraints.userId, userId.toString());
        sharedPref.setString(AppConstraints.userName, userName);
        sharedPref.setString(AppConstraints.userEmail, userEmail);


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
        Get.offAll(const BottomNaveBarPage());

        // Clear Text Field
        emailController.clear();
        passwordController.clear();

        // loader
        isLoading.value = false;

      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occurred';
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

  // Check user is Login
  Future<bool> isUserLogin() async{
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if(sharedPref.containsKey(AppConstraints.userId) && sharedPref.getString(AppConstraints.userId)!.isNotEmpty){
      userLogin.value = true;
      return Future.value(true);
    }else{
      userLogin.value = false;
      return Future.value(false);
    }

  }
//
}
