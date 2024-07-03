
import 'dart:convert';
import 'package:assalam/data/models/prayer_time_models/prayer_time_data_model.dart';
import 'package:http/http.dart' as http;

class PrayerTimeGetData {
  Map<String, dynamic> prayerTimeData = {};

  Future<PrayerTimeDataModel> fetchPrayerTimeData(String date,String city, String country) async {

    try {
      final response = await http.get(Uri.parse('https://assalam.icam.com.bd/public/api/prayerTime/$date/$city/$country'));

      if (response.statusCode == 200) {
        prayerTimeData = json.decode(response.body);
        print(response.body);
      } else {
        print('Api Error: ${response.statusCode}');
        // Handle other API errors
        return PrayerTimeDataModel(); // or whatever you want to return in case of an API error
      }
    } on Exception catch (e) {
      print('Error: $e');
      // Handle other exceptions
      return PrayerTimeDataModel(); // or whatever you want to return in case of an exception
    }

    return PrayerTimeDataModel.fromJson(prayerTimeData);
  }
}