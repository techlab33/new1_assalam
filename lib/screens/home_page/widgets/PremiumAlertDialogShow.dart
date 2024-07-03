import 'package:assalam/screens/premium_page/premium_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumAlertDialogShow extends StatelessWidget {
  const PremiumAlertDialogShow({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: screenSize.height / 3,
        width: double.infinity,
        //color: TColors.primaryColor,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logos/assalam_green-logo.png', height: 70, width: 70),
            SizedBox(height: 20),
            Text('This Feature is Only for Premium Members.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),textAlign: TextAlign.center),
            SizedBox(height: 40),
            InkWell(
              onTap: () => Get.to(PackageListScreen()),
              child: Container(
                alignment: Alignment.center,
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.orange,
                    ],
                  ),
                ),
                child: Text('Get Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}