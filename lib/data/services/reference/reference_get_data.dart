
import 'dart:convert';
import 'dart:developer';
import 'package:assalam/data/models/reference/reference_data_model.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReferenceGetData {
  Map<String, dynamic> referralData = {};

  Future<ReferenceDataModel> fetchReferenceData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/userReferList/$id'));

      if (response.statusCode == 200) {
        referralData = json.decode(response.body);
        log(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return ReferenceDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
      return ReferenceDataModel(); // or whatever you want to return in case of an exception
    }

    return ReferenceDataModel.fromJson(referralData);
  }
}