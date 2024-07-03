
import 'package:assalam/common/widgets/custom_container_button.dart';
import 'package:assalam/common/widgets/custom_text_field.dart';
import 'package:assalam/controller/auth_controller/registration_controller.dart';
import 'package:assalam/screens/authentication/log_in_page/login_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:assalam/utils/helper/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // Registration Controller
    final registerController = Get.put(RegistrationController());

    // Screen Size
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width / 22),
            child: Form(
               key: formKey,
              child: Obx( () =>  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Let's get started text
                        Text("Create Your Account", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        //
                        Text("Login and Enjoy your AsSalam App", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),

                        SizedBox(height: screenSize.height / 19.7),

                        // Name text
                        Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(height: screenSize.height / 98.5),

                        // Name Text field
                        CustomTextField(
                          validator: (value) => TValidator.validateEmptyText('Name', value),
                          textEditingController: registerController.nameController,
                          hintText: 'Name',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.person_outline,
                          isSuffixIcon: false,
                        ),
                        SizedBox(height: screenSize.height / 98.5),

                        // User text
                        Text("Username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(height: screenSize.height / 98.5),

                        // Name Text field
                        CustomTextField(
                          validator: (value) => TValidator.validateEmptyText('Username', value),
                          textEditingController: registerController.usernameController,
                          hintText: 'Username',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.person_outline,
                          isSuffixIcon: false,
                        ),

                        SizedBox(height: screenSize.height / 98.5),

                        // Email text
                        Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(height: screenSize.height / 98.5),

                        // Email Text field
                        CustomTextField(
                          validator: (value) => TValidator.validateEmail(value),
                          textEditingController: registerController.emailController,
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
                          textEditingController: registerController.passwordController,
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock_outline_rounded,
                          isSuffixIcon: true,
                        ),

                        // SizedBox(height: screenSize.height / 39.4),
                        //
                        // // Password text
                        // Text("Have any refer Id? ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                        // SizedBox(height: screenSize.height / 98.5),
                        //
                        // // Password Text field
                        // CustomTextField(
                        //   textEditingController: registerController.referController,
                        //   hintText: 'Refer Code',
                        //   keyboardType: TextInputType.visiblePassword,
                        //   prefixIcon: Icons.add,
                        //   isSuffixIcon: false,
                        // ),

                        //SizedBox(height: screenSize.height / .5),

                        // Already have an Account
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an Account?',style: TextStyle(fontFamily: 'Roboto',fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                              TextButton(onPressed: () => Get.to(LoginScreen()), child:  Text('  Log In',style: TextStyle(fontFamily: 'Roboto',fontSize: 15, fontWeight: FontWeight.w600, color: Colors.green))),
                            ],
                          ),
                        ),

                        //SizedBox(height: 5),

                        SizedBox(height: screenSize.height / 18.13),

                        GestureDetector(
                          onTap: () {
                            if(formKey.currentState!.validate()) {
                              registerController.registration();
                            }
                          },
                          child: registerController.isLoading.value ? const Center(child: CircularProgressIndicator()) :  CustomContainerButton(text: 'Registration'),
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

