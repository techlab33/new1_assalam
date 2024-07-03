
import 'dart:convert';
import 'package:assalam/data/models/hadith/all_hadith_data_model.dart';
import 'package:http/http.dart' as http;

class GetAllHadithData {
  Map<String, dynamic> allHadithData = {};

  Future<AllHadithDataModel> fetchAllHadithData() async {

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/get-hadis-book'));

      if (response.statusCode == 201) {
        allHadithData = json.decode(response.body);

      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return AllHadithDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
      return AllHadithDataModel(); // or whatever you want to return in case of an exception
    }

    return AllHadithDataModel.fromJson(allHadithData);
  }
}

