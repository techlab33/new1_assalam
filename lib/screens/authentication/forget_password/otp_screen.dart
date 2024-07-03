import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Screen', style: TextStyle(color: TColors.primaryColor)),
        backgroundColor: TColors.primaryColor,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [

                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter OTP',
                    label: Text('OTP'),
                  ),
                ),
                SizedBox(height: 50),

                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: TColors.primaryColor,
                  ),
                  child: Text('Send OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
