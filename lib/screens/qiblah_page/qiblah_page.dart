import 'dart:math' show pi, sin, cos, atan2, tan;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';


class QiblaPage extends StatefulWidget {
  @override
  _QiblaPageState createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double _direction = 0;
  double _qiblaDirection = 0;
  Position? _currentPosition;
  final double kaabaLat = 21.4225;
  final double kaabaLong = 39.8262;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus.isGranted) {
      _getCurrentLocation();
      _initCompass();
      setState(() {
        _hasPermissions = true;
      });
    } else {
      setState(() {
        _hasPermissions = false;
      });
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _calculateQiblaDirection();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading ?? 0;
      });
    });
  }

  void _calculateQiblaDirection() {
    if (_currentPosition != null) {
      double lat = _currentPosition!.latitude;
      double long = _currentPosition!.longitude;

      double latRad = _toRadians(lat);
      double longRad = _toRadians(long);
      double kaabaLatRad = _toRadians(kaabaLat);
      double kaabaLongRad = _toRadians(kaabaLong);

      double y = sin(kaabaLongRad - longRad);
      double x = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(kaabaLongRad - longRad);

      double qiblaRad = atan2(y, x);
      double qiblaDeg = _toDegrees(qiblaRad);

      setState(() {
        _qiblaDirection = (qiblaDeg + 360) % 360;
      });
    }
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  double _toDegrees(double radian) {
    return radian * 180 / pi;
  }

  String _getCardinalDirection(double degrees) {
    const List<String> cardinals = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"];
    return cardinals[(degrees / 45).round() % 8];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Qibla Direction')),
      body: _hasPermissions
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Qibla Direction: ${_qiblaDirection.toStringAsFixed(2)}° (${_getCardinalDirection(_qiblaDirection)})',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: CustomPaint(
                  painter: CompassPainter(_direction),
                ),
              ),
              Transform.rotate(
                angle: ((_qiblaDirection - _direction) * (pi / 180)),
                child: Icon(Icons.arrow_upward, size: 120, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Current Location:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            _currentPosition != null
                ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                : 'Unknown',
            style: TextStyle(fontSize: 16),
          ),
        ],
      )
          : Center(
        child: Text(
          'Location permission is required to use this app.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double direction;

  CompassPainter(this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint);

    final markerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    for (int i = 0; i < 360; i += 30) {
      final angle = (i - direction) * (pi / 180);
      final markerStart = Offset(
        center.dx + (radius - 10) * cos(angle),
        center.dy + (radius - 10) * sin(angle),
      );
      final markerEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawLine(markerStart, markerEnd, markerPaint);

      if (i % 90 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: ['E', 'N', 'W', 'S'][i ~/ 90],
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            center.dx + (radius - 30) * cos(angle) - textPainter.width / 2,
            center.dy + (radius - 30) * sin(angle) - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}