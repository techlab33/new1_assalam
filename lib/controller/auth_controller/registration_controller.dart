import 'dart:convert';

import 'package:assalam/screens/authentication/log_in_page/login_page.dart';
import 'package:assalam/utils/constants/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationController extends GetxController {
  //
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referController = TextEditingController();

  RxBool isLoading = false.obs;

  // Registration
  Future<void> registration() async {

    try {
      // Loader
      isLoading.value = true;

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);

      Map body = {
        'name': nameController.text.toString(),
        'username': usernameController.text.toString(),
        'email': emailController.text.toString(),
        'password': passwordController.text.toString().trim(),
        // 'refer_from': referController.text.toString().trim(),
      };

      http.Response response = await http.post(url, body: body);
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var userId = json["user"]["id"];
        print('User Id = $userId');


        // Clear Text Field
        nameController.clear();
        emailController.clear();
        passwordController.clear();

        // Loader
        isLoading.value = false;

        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['message'] ,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );

        // Navigate Login Screen
        Get.to(const LoginScreen());
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
      // Loader
      isLoading.value = false;
    }
  }
}
