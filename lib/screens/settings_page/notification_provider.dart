import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  List<String> notificationSounds = ['azan', 'azan2', 'azan3', 'azan4','azan5'];
  String selectedSound = ''; // Default sound
  bool notificationsEnabled = true; // Default notifications enabled
  Map<String, bool> _notificationsStatus = {};

  NotificationProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    selectedSound = _prefs!.getString('selectedSound') ?? selectedSound; // Load saved sound or default
    notificationsEnabled = _prefs!.getBool('notificationsEnabled') ?? true; // Load saved state or default

    for (String prayer in _notificationsStatus.keys) {
      _notificationsStatus[prayer] = _prefs!.getBool(prayer) ?? true;
    }

    notifyListeners();
  }

  void setNotificationSound(String sound) async {
    selectedSound = sound;
    notifyListeners();
    await _prefs!.setString('selectedSound', sound); // Save selected sound
  }

  void toggleAllNotifications(bool value) async {
    notificationsEnabled = value;
    notifyListeners();
    await _prefs!.setBool('notificationsEnabled', value); // Save state

    // Disable individual notifications if all notifications are disabled
    if (!value) {
      for (String prayer in _notificationsStatus.keys) {
        _notificationsStatus[prayer] = false;
        await _prefs!.setBool(prayer, false);
      }
    }
  }

  void toggleNotification(String prayer, bool value) async {
    _notificationsStatus[prayer] = value;
    notifyListeners();
    await _prefs!.setBool(prayer, value); // Save individual notification state
  }

  bool isNotificationEnabled(String prayer) {
    return _notificationsStatus[prayer] ?? true;
  }
}
