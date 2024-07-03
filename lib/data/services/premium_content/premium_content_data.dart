
import 'dart:convert';
import 'package:assalam/data/models/prayer_time_models/prayer_time_data_model.dart';
import 'package:http/http.dart' as http;

import '../../models/premium_content/premium_content_data_model.dart';

class PremiumContentGetData {
  Map<String, dynamic> premiumContentData = {};

  Future<PremiumContentDataModel> fetchPremiumContentData() async {

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/premium-content'));

      if (response.statusCode == 201) {
        premiumContentData = json.decode(response.body);
        print(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return PremiumContentDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
      return PremiumContentDataModel(); // or whatever you want to return in case of an exception
    }

    return PremiumContentDataModel.fromJson(premiumContentData);
  }
}