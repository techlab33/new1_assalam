
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:intl/intl.dart';

class PrayerTimeController extends GetxController {
  //
  Position? _currentPosition;
  String? currentCity;
  String? currentCountry;
  RxBool isLoading = false.obs;


  // Get User Current Location
  void getCurrentLocation() async {
    isLoading.value = true;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, handle appropriately
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Location permission is required")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permanent permission denial
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Location permission is denied forever")),
      );
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    getAddressFromLatLng();
    isLoading.value = false;
  }

  void getAddressFromLatLng() async {
    if (_currentPosition != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        currentCity = placemark.locality;
        currentCountry = placemark.country;
      }
    }
  }
}