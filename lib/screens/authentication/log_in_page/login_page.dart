import 'package:assalam/common/widgets/custom_container_button.dart';
import 'package:assalam/common/widgets/custom_text_field.dart';
import 'package:assalam/controller/auth_controller/login_controller.dart';
import 'package:assalam/controller/auth_controller/send_otp_controller.dart';
import 'package:assalam/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:assalam/screens/authentication/forget_password/otp_screen.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:assalam/utils/helper/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Is Remember me
  bool isRememberMe = false;

  // Form key
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    // Registration Controller
    final loginController = Get.put(LoginController());

    // Screen Size
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width / 22),
            child: Form(
              key: formKey,
              child: Obx( () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Let's get started text
                      Text("Welcome Back!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                      SizedBox(height: screenSize.height / 88),
                      //
                      Text("Login and Enjoy your AsSalam App", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),

                      SizedBox(height: screenSize.height / 19.7),

                      // Email text
                      Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(height: screenSize.height / 98.5),

                      // Email Text field
                      CustomTextField(
                        validator: (value) => TValidator.validateEmail(value),
                        textEditingController: loginController.emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        isSuffixIcon: false,
                      ),

                      SizedBox(height: screenSize.height / 39.4),

                      // Password text
                      Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(height: screenSize.height / 98.5),

                      // Password Text field
                      CustomTextField(
                        validator: (value) => TValidator.validatePassword(value),
                        textEditingController: loginController.passwordController,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        isSuffixIcon: true,
                      ),
                      SizedBox(height: screenSize.height / 80.53),

                      // Remember me & Forget Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                          },
                            child: Text("Forget Password?",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400),
                            ),),

                        ],
                      ),

                      SizedBox(height: 5),

                      SizedBox(height: screenSize.height / 13.13),

                      GestureDetector(
                        onTap: () {
                           if(formKey.currentState!.validate()){
                             loginController.login();
                           }
                        },
                        child : loginController.isLoading.value ? const Center(child: CircularProgressIndicator()) : CustomContainerButton(text: 'Log In'),
                      ),
                    ],
                  ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}

