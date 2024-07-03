
import 'dart:convert';
import 'package:assalam/data/models/dua_model/dua_data_model.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetAllDua {
  Map<String, dynamic> allDuaData = {};

  Future<DuaDataModel> fetchAllDuaData() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/get-doa/$id'));

      if (response.statusCode == 201) {
        allDuaData = json.decode(response.body);
        print(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return DuaDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
      return DuaDataModel(); // or whatever you want to return in case of an exception
    }

    return DuaDataModel.fromJson(allDuaData);
  }
}
