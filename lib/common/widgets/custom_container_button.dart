import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomContainerButton extends StatelessWidget {
  CustomContainerButton({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 14,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: TColors.primaryColor,
      ),
      child: Text(
        textAlign: TextAlign.center,
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
