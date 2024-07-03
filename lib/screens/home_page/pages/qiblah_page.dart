
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class QiblaDirectionPage extends StatefulWidget {
  @override
  _QiblaDirectionPageState createState() => _QiblaDirectionPageState();
}

class _QiblaDirectionPageState extends State<QiblaDirectionPage> {

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      // Request permission
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      _getCurrentLocation(); // Permission granted, get location
    } else {
      // Permission denied, handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission is required to determine Qibla direction.")),
      );
    }
  }

  void _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double _calculateQiblaDirection() {
    if (_currentPosition == null) return 0.0;

    double lat1 = _currentPosition!.latitude;
    double lon1 = _currentPosition!.longitude;

    double lat2 = 21.4225; // Kaaba latitude
    double lon2 = 39.8262; // Kaaba longitude

    double deltaLon = lon2 - lon1;

    double y = sin(deltaLon * pi / 180) * cos(lat2 * pi / 180);
    double x = cos(lat1 * pi / 180) * sin(lat2 * pi / 180) - sin(lat1 * pi / 180) * cos(lat2 * pi / 180) * cos(deltaLon * pi / 180);

    double bearing = atan2(y, x) * 180 / pi - 1;

    return (bearing + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Direction'),
      ),
      body: Center(
        child: StreamBuilder<CompassEvent?>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double? compassDirection = snapshot.data!.heading;
              double qiblaDirection = _calculateQiblaDirection();
              double angle = (qiblaDirection - compassDirection! + 360) % 360;

              return Transform.rotate(
                angle: angle * pi / 180, // Convert degrees to radians
                child: Image.asset('assets/images/qibla-compass.png', height: 300, width: 300,),
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}