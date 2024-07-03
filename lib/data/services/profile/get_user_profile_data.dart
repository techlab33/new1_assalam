
import 'dart:convert';
import 'dart:developer';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileGetData {

  Map<String, dynamic> userProfileData = {};

  Future<UserProfileDataModel> fetchUserProfileData() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(AppConstraints.userId);
    int id = int.parse(userId!);
    
    try {
      final http.Response response = await http.get(Uri.parse('https://assalam.icam.com.bd/public/api/profile/$id'));

      if(response.statusCode == 200) {
        userProfileData = json.decode(response.body);
         // log(response.body);
         // log('User Id ${id.toString()}');
      }else {
        log('Api Error : ${response.statusCode}');
        return UserProfileDataModel();
      }
      
    }on Exception catch (e) {
      log('Error : $e');
      return UserProfileDataModel();
    }
    return UserProfileDataModel.fromJson(userProfileData);

  }
}