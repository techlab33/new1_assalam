
import 'dart:convert';
import 'dart:developer';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ClaimLiveRewardGetData {

  Map<String, dynamic> claimLiveRewardData = {};

  Future ClaimLiveRewardData() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);

    try {
      final http.Response response = await http.get(Uri.parse('https://assalam.icam.com.bd/public/api/liveclaim/$id'));

      if(response.statusCode == 200) {
        claimLiveRewardData = json.decode(response.body);
        log(response.body);
        log('User Id ${id.toString()}');
      }
      else if(response.statusCode == 201) {
        claimLiveRewardData = json.decode(response.body);
        log(response.body);
        log('Api Error : ${response.statusCode}');
      } else if(response.statusCode == 404) {
        claimLiveRewardData = json.decode(response.body);
        log(response.body);
      }

    }on Exception catch (e) {
      log('Error : $e');
    }

  }
}