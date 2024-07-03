import 'package:assalam/common/widgets/custom_text_field.dart';
import 'package:assalam/controller/auth_controller/send_otp_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:assalam/utils/helper/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final formKey = GlobalKey<FormState>();
  final sendOtpController = Get.put(SendOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password',style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.w500),),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(() => Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  // Email Text field
                  CustomTextField(
                    validator: (value) => TValidator.validateEmail(value),
                    textEditingController: sendOtpController.forgetEmailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    isSuffixIcon: false,
                  ),
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      if(formKey.currentState!.validate()) {
                        sendOtpController.sendOtp();
                      }
                    },
                    child: sendOtpController.isLoading == false ? Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: TColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('Send', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ) : Center(child: CircularProgressIndicator(color: TColors.primaryColor,)),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
