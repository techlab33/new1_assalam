
import 'dart:convert';
import 'package:assalam/data/models/hadith/hadith_book_data_model.dart';
import 'package:http/http.dart' as http;

class GetHadithBookData {
  Map<String, dynamic> hadithBookData = {};

  Future<HadithBookDataModel> fetchHadithBookData(String apiUrl) async {

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        hadithBookData = json.decode(response.body);
        // print(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
         return HadithBookDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
       return HadithBookDataModel();// or whatever you want to return in case of an exception
    }

    return HadithBookDataModel.fromJson(hadithBookData);
  }
}

