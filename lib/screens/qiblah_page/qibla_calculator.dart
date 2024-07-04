import 'dart:math';

class QiblaCalculator {
  static const double meccaLatitude = 21.4225;
  static const double meccaLongitude = 39.8262;

  static double calculateQiblaDirection(double latitude, double longitude) {
    var lat1 = _degreesToRadians(latitude);
    var lon1 = _degreesToRadians(longitude);
    var lat2 = _degreesToRadians(meccaLatitude);
    var lon2 = _degreesToRadians(meccaLongitude);

    var dLon = lon2 - lon1;

    var y = sin(dLon) * cos(lat2);
    var x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    var brng = atan2(y, x);

    return (_radiansToDegrees(brng) + 360) % 360;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double _radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }
}
