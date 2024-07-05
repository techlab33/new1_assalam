// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationProvider with ChangeNotifier {
//   SharedPreferences? _prefs;
//   List<String> notificationSounds = ['azan', 'azan2', 'azan3', 'azan4','azan5'];
//   String selectedSound = 'azan'; // Default sound
//   bool notificationsEnabled = true; // Default notifications enabled
//   Map<String, bool> _notificationsStatus = {};
//
//   NotificationProvider() {
//     _loadPreferences();
//   }
//
//   Future<void> _loadPreferences() async {
//     _prefs = await SharedPreferences.getInstance();
//     selectedSound = _prefs!.getString('selectedSound') ?? selectedSound; // Load saved sound or default
//     notificationsEnabled = _prefs!.getBool('notificationsEnabled') ?? true; // Load saved state or default
//
//     for (String prayer in _notificationsStatus.keys) {
//       _notificationsStatus[prayer] = _prefs!.getBool(prayer) ?? true;
//     }
//
//     notifyListeners();
//   }
//
//   void setNotificationSound(String sound) async {
//     selectedSound = sound;
//     notifyListeners();
//     await _prefs!.setString('selectedSound', sound); // Save selected sound
//   }
//
//   void toggleAllNotifications(bool value) async {
//     notificationsEnabled = value;
//     notifyListeners();
//     await _prefs!.setBool('notificationsEnabled', value); // Save state
//
//     // Disable individual notifications if all notifications are disabled
//     if (!value) {
//       for (String prayer in _notificationsStatus.keys) {
//         _notificationsStatus[prayer] = false;
//         await _prefs!.setBool(prayer, false);
//       }
//     }
//   }
//
//   void toggleNotification(String prayer, bool value) async {
//     _notificationsStatus[prayer] = value;
//     notifyListeners();
//     await _prefs!.setBool(prayer, value); // Save individual notification state
//   }
//
//   bool isNotificationEnabled(String prayer) {
//     return _notificationsStatus[prayer] ?? true;
//   }
// }



import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  List<String> notificationSounds = ['azan', 'azan2', 'azan3', 'azan4', 'azan5'];
  String selectedSound = 'azan'; // Default sound
  bool notificationsEnabled = true; // Default notifications enabled
  Map<String, bool> notificationsStatus = {}; // Individual notifications status

  NotificationProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load selected sound
    selectedSound = _prefs!.getString('selectedSound') ?? selectedSound;

    // Load notifications enabled state
    notificationsEnabled = _prefs!.getBool('notificationsEnabled') ?? notificationsEnabled;

    // Initialize notifications status
    for (String sound in notificationSounds) {
      notificationsStatus[sound] = _prefs!.getBool(sound) ?? true;
    }

    notifyListeners();
  }

  void setNotificationSound(String sound) async {
    selectedSound = sound;
    notifyListeners();
    await _prefs!.setString('selectedSound', sound);
  }

  void toggleAllNotifications(bool value) async {
    notificationsEnabled = value;
    notifyListeners();
    await _prefs!.setBool('notificationsEnabled', value);

    // Disable individual notifications if all notifications are disabled
    if (!value) {
      for (String sound in notificationSounds) {
        notificationsStatus[sound] = false;
        await _prefs!.setBool(sound, false);
      }
    }
    notifyListeners(); // Notify listeners after the loop completes
  }

  void toggleNotification(String sound, bool value) async {
    notificationsStatus[sound] = value;
    notifyListeners();
    await _prefs!.setBool(sound, value);
  }

  bool isNotificationEnabled(String sound) {
    return notificationsStatus[sound] ?? true;
  }
}
