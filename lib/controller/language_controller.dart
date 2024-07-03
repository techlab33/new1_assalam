import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  RxString _language = "".obs;
  StreamController<String> _languageStreamController = StreamController<String>.broadcast();

  String get language => _language.value;
  Stream<String> get languageStream => _languageStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void setLanguage(String languageCode) async {
    _language.value = languageCode;
    _languageStreamController.add(languageCode); // Emit the new language to the stream
    await _saveLanguage(languageCode);
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _language.value = prefs.getString('language') ?? 'en'; // Default language is English
  }

  Future<void> _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  @override
  void dispose() {
    _languageStreamController.close(); // Close the stream controller when not needed anymore
    super.dispose();
  }
}
