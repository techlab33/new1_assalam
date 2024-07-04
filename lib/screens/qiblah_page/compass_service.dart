import 'package:flutter_compass/flutter_compass.dart';

class CompassService {
  Stream<CompassEvent>? get heading => FlutterCompass.events;
}
