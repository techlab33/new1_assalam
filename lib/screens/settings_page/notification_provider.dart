import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = true;
  String _selectedSound = 'azan';
  Map<String, bool> _prayerNotifications = {
    'Fajr': true, 'Dhuhr': true, 'Asr': true, 'Maghrib': true, 'Isha': true
  };
  List<String> notificationSounds = ['azan', 'azan2', 'azan3', 'azan4'];
  Map<String, dynamic> _prayerTimes = {};
  String _city = '';
  String _country = '';
  Map<String, String> _notificationMessages = {};

  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedSound => _selectedSound;

  NotificationProvider() {
    _initializeNotifications();
    _loadSavedSound();
    _fetchNotificationMessages();
    _getCurrentLocation();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadSavedSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedSound = prefs.getString('selectedSound') ?? 'Default';
    notifyListeners();
  }

  Future<void> _saveSelectedSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSound', _selectedSound);
  }

  Future<void> _fetchNotificationMessages() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/techlab33/nubtk/main/new.json'));
    if (response.statusCode == 200) {
      _notificationMessages = Map<String, String>.from(json.decode(response.body));
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        _city = placemarks[0].locality ?? '';
        _country = placemarks[0].country ?? '';
        await _fetchPrayerTimes();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchPrayerTimes() async {
    final date = DateTime.now().toString().split(' ')[0];
    final url = Uri.parse('https://assalam.icam.com.bd/public/api/prayerTime/$date/$_city/$_country');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _prayerTimes = Map<String, dynamic>.from(data['data']);
      await _schedulePrayerNotifications();
    }
  }

  Future<void> setNotificationSound(String sound) async {
    _selectedSound = sound;
    await _saveSelectedSound();
    await _schedulePrayerNotifications();
    notifyListeners();
  }

  void toggleAllNotifications(bool value) {
    _notificationsEnabled = value;
    _prayerNotifications.forEach((key, _) {
      _prayerNotifications[key] = value;
    });
    _schedulePrayerNotifications();
    notifyListeners();
  }

  void toggleNotification(String prayerName, bool value) {
    _prayerNotifications[prayerName] = value;
    _schedulePrayerNotifications();
    notifyListeners();
  }

  bool isNotificationEnabled(String prayerName) {
    return _prayerNotifications[prayerName] ?? false;
  }

  Future<void> _schedulePrayerNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();

    if (!_notificationsEnabled) return;

    _prayerTimes.forEach((prayerName, time) {
      if (_prayerNotifications[prayerName] ?? false) {
        _scheduleNotification(prayerName, time);
      }
    });
  }

  Future<void> _scheduleNotification(String prayerName, String time) async {
    final now = DateTime.now();
    final timeComponents = time.split(':');
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    String soundFile = 'azan.wav';
    if (_selectedSound != 'azan') {
      soundFile = '${_selectedSound.toLowerCase()}.wav';
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'prayer_notifications',
      'Prayer Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(soundFile.split('.').first),
    );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(sound: soundFile);

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      prayerName.hashCode,
      'Prayer Time',
      _notificationMessages[prayerName] ?? 'It\'s time for $prayerName prayer in $_city, $_country',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void refreshLocation() {
    _getCurrentLocation();
  }
}