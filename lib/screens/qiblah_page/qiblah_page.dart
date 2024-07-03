import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;


class QiblaPage extends StatefulWidget {
  @override
  _QiblaCompassState createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaPage> {

  double? _direction;
  double? _qiblaDirection;
  double? _makkahDirection;
  Position? _currentPosition;

  final double makkahLat = 21.4225;
  final double makkahLon = 39.8262;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCompassDirection();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    _calculateDirections();
  }

  void _getCompassDirection() {
    FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading;
      });
    });
  }

  void _calculateDirections() {
    if (_currentPosition != null) {
      final kaaba = _toRadians(makkahLat);
      final kaaba_lon = _toRadians(makkahLon);
      final lat = _toRadians(_currentPosition!.latitude);
      final lon = _toRadians(_currentPosition!.longitude);

      final y = math.sin(kaaba_lon - lon);
      final x = math.cos(lat) * math.tan(kaaba) -
          math.sin(lat) * math.cos(kaaba_lon - lon);

      var qibla = math.atan2(y, x);
      qibla = _toDegrees(qibla);
      qibla = (qibla + 360) % 360;

      final dLon = kaaba_lon - lon;
      final y_makkah = math.sin(dLon) * math.cos(kaaba);
      final x_makkah = math.cos(lat) * math.sin(kaaba) -
          math.sin(lat) * math.cos(kaaba) * math.cos(dLon);

      var makkah = math.atan2(y_makkah, x_makkah);
      makkah = _toDegrees(makkah);
      makkah = (makkah + 360) % 360;

      setState(() {
        _qiblaDirection = qibla;
        _makkahDirection = makkah;
      });
    }
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  double _toDegrees(double radian) {
    return radian * 180 / math.pi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Qibla Direction')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_direction != null && _qiblaDirection != null)
              Stack(
                    children: [
                      Container(
                        child: Transform.rotate(
                          angle: ((_direction! - _qiblaDirection!) * (math.pi / 180) * -1),
                          child: Image.asset('assets/images/compass.png', scale: 1.5),
                        ),
                      ),
                      Container(
                          child:Transform.rotate(
                            angle: ((_direction! - _makkahDirection!) * (math.pi / 180) * -1),
                            child: Image.asset('assets/images/kata.png', scale: 1.5),
                          )
                      )
        ],
      ),

            SizedBox(height: 20),
            Text(
              'Qibla Direction: ${_qiblaDirection?.toStringAsFixed(2) ?? "Calculating..."}°',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Makkah Direction: ${_makkahDirection?.toStringAsFixed(2) ?? "Calculating..."}°',
              style: TextStyle(fontSize: 20),
            ),

          ],
        ),
      ),
    );
  }
}