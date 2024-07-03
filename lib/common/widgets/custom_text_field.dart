import 'package:assalam/controller/auth_controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.isSuffixIcon,
    this.validator,
  });

  final TextEditingController textEditingController;
  String hintText;
  IconData prefixIcon;
  TextInputType keyboardType;
  bool  isSuffixIcon = true;
  String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  //bool  obscureText = true;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        obscureText: widget.isSuffixIcon ? hidePassword : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle( fontSize: 14),
          prefixIcon: Icon(widget.prefixIcon, size: 20, color: Colors.green,),
          border: InputBorder.none,
          suffixIcon: widget.isSuffixIcon ? IconButton(
            onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
            },
            icon: Icon( hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          ) : null,
        ),
      ),
    );
  }
}
