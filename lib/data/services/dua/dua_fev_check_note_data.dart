

import 'dart:developer';

import 'package:assalam/utils/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DuaFevCheckNote {


  // Favorite Button
  Future duaFavoriteData(int duaId, String fev)  async{

    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(AppConstraints.userId);
      int id = int.parse(userId!);

      final  response = await  http.post(Uri.parse('https://assalam.icam.com.bd/api/insert-doa-user/${id}/${duaId}/${fev}/empty/empty'));

      if(response.statusCode == 200) {

        print(response.body);
      }else {
        print('Api Error');
      }

    }on Exception catch  (e) {
      print('Error: $e');
    }

  }

  // Check Button
  Future duaCheckData(int duaId, String check)  async{

    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(AppConstraints.userId);
      int id = int.parse(userId!);

      final  response = await  http.post(Uri.parse('https://assalam.icam.com.bd/api/insert-doa-user/${id}/${duaId}/empty/$check/empty'));

      if(response.statusCode == 200) {

        print(response.body);
      }else {
        print('Api Error');
      }

    }on Exception catch  (e) {
      print('Error: $e');
    }

  }
  // Note Button
  Future duaNoteData(int duaId, String note)  async{

    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(AppConstraints.userId);
      int id = int.parse(userId!);

      final  response = await  http.post(Uri.parse('https://assalam.icam.com.bd/api/insert-doa-user/${id}/${duaId}/empty/empty/$note'));

      if(response.statusCode == 200) {
        log(response.body);
      }else {
        print('Api Error');
      }
    }on Exception catch  (e) {
      print('Error: $e');
    }

  }

}