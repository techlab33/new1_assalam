import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  String? currentCity;
  String? currentCountry;
  bool locationFetched = false;

  Future<void> requestPermissionAndFetchLocation() async {
    if (locationFetched) return; // Do nothing if location already fetched

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle if permission is denied or permanently denied
      return;
    } else {
      await getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      print('City: ${placemark.locality}, Country: ${placemark.country}');
      currentCity = placemark.locality;
      currentCountry = placemark.country;
      locationFetched = true;
    }
  }
}
