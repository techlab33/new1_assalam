
import 'dart:convert';
import 'dart:developer';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LiveBalanceSavingRewardData {

  Map<String, dynamic> liveBalanceSavingRewardData = {};

  Future LiveBalanceSavingRewardGetData() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);

    try {
      final http.Response response = await http.get(Uri.parse('https://assalam.icam.com.bd/api/savingCheck/$id'));

      if(response.statusCode == 200) {
        liveBalanceSavingRewardData = json.decode(response.body);
        log(response.body);
        log('User Id ${id.toString()}');
      }
      else if(response.statusCode == 201) {
        liveBalanceSavingRewardData = json.decode(response.body);
        log(response.body);
        log('Api Error : ${response.statusCode}');
      } else if(response.statusCode == 404) {
        liveBalanceSavingRewardData = json.decode(response.body);
        log(response.body);
      }

    }on Exception catch (e) {
      log('Error : $e');
    }
  }
}