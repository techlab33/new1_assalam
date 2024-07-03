
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {

  Rx<File> image = File('').obs;

  ImagePicker picker = ImagePicker();

  Future imagePickerMethodGallery(ImageSource source) async {
      final pick = await picker.pickImage(source: source);
        if (pick != null) {
          final imagePath = File(pick.path);
          image.value = imagePath;
          Navigator.pop(Get.context!);
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('No File selected'), duration: Duration(milliseconds: 600),));
        }
    }


}