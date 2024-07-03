

import 'dart:convert';
import 'package:assalam/data/models/quran_model/quran_data_model.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetAllQuran {
  Map<String, dynamic> allQuranData = {};

  Future<QuranDataModel> fetchAllQuranData() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/transformQuranData'));

      if (response.statusCode == 200) {
        allQuranData = json.decode(response.body);
        print(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return QuranDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
       return QuranDataModel(); // or whatever you want to return in case of an exception
    }

    return QuranDataModel.fromJson(allQuranData);
  }
}