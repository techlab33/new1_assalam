import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final List<String> prayerNames = [
     'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  ];

  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlayingSound;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    initNotifications();
    requestNotificationPermission();
  }

  Future<void> toggleSound(String soundName) async {
    if (currentlyPlayingSound == soundName) {
      await audioPlayer.pause();
      setState(() {
        currentlyPlayingSound = null;
      });
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/$soundName.wav'));
      setState(() {
        currentlyPlayingSound = soundName;
      });
    }
  }

  void initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@drawable/notification_icon');
    const initializationSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    if (status == PermissionStatus.granted) {
      downloadJson();
    } else {
      print('Notification permission denied');
    }
  }

  Future<void> downloadJson() async {
    final response = await http.get(Uri.parse("https://raw.githubusercontent.com/techlab33/nubtk/main/new.json"));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
      scheduleNotifications();
    } else {
      throw Exception("Something went wrong while fetching data.");
    }
  }

  void scheduleNotifications() {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    if (!notificationProvider.notificationsEnabled) {
      return;
    }

    final now = DateTime.now();
    final scheduledTimes = {
      // 'Imsak': Time(5, 0, 0),
      'Fajr': Time(5, 3, 0),
      // 'Sunrise': Time(16, 20, 0),
      // 'Dhuha': Time(17, 8, 0),
      'Dhuhr': Time(11, 58, 0),
      'Asr': Time(15, 20, 0),
      'Maghrib': Time(17, 51, 0),
      'Isha': Time(18, 51, 0),
    };

    final notificationSound = notificationProvider.selectedSound;

    for (var entry in scheduledTimes.entries) {
      if (notificationProvider.isNotificationEnabled(entry.key)) {
        var scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          entry.value.hour,
          entry.value.minute,
          entry.value.second,
        );
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(Duration(days: 1));
        }

        final notificationBody = posts.firstWhere((post) => post['name'] == entry.key)['name'] as String;
        final android = AndroidNotificationDetails(
          'scheduled_notification',
          'Scheduled Notifications',
          playSound: true,
          sound: RawResourceAndroidNotificationSound(notificationSound),
          importance: Importance.max,
          priority: Priority.high,
        );
        final platform = NotificationDetails(android: android);
        flutterLocalNotificationsPlugin.zonedSchedule(
          prayerNames.indexOf(entry.key),
          'ASSALAM',
          notificationBody,
          tz.TZDateTime.from(scheduledDate, tz.local),
          platform,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  void cancelIshaNotification() {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf('Isha'));
  }
  void cancelFajrNotification() {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf('Fajr'));
  }

  void cancelDhuhrNotification() {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf('Dhuhr'));
  }

  void cancelAsrNotification() {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf('Asr'));
  }

  void cancelMaghribNotification() {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf('Maghrib'));
  }

  void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: TColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Select Notification Sound', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: notificationProvider.notificationSounds.map((sound) {
                  bool isPlaying = currentlyPlayingSound == sound;
                  return Card(
                    child: ListTile(
                      title: Text(sound),
                      trailing: IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          toggleSound(sound);
                          notificationProvider.setNotificationSound(sound);
                        },
                      ),
                      selected: notificationProvider.selectedSound == sound,
                      onTap: () {
                        toggleSound(sound);
                        notificationProvider.setNotificationSound(sound);
                      },
                      selectedTileColor: Colors.greenAccent[100],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Enable All Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              value: notificationProvider.notificationsEnabled,
              onChanged: (value) {
                notificationProvider.toggleAllNotifications(value);
                if (value) {
                  scheduleNotifications();
                } else {
                  cancelAllNotifications();
                  audioPlayer.pause();
                  setState(() {
                    currentlyPlayingSound = null;
                  });
                }
                for (var prayerName in prayerNames) {
                  notificationProvider.toggleNotification(prayerName, value);
                }
              },
              activeColor: TColors.primaryColor,
            ),
            SizedBox(height: 10),
            ...prayerNames.map((prayerName) {
              final isEnabled = notificationProvider.isNotificationEnabled(prayerName);
              return SwitchListTile(
                title: Text(prayerName),
                value: isEnabled,
                onChanged: (value) {
                  notificationProvider.toggleNotification(prayerName, value);
                  if (prayerName == 'Isha' || prayerName =='Fajr' || prayerName=='Dhuhr' || prayerName=='Asr' || prayerName=='Maghrib') {
                    if (!value) {
                      cancelIshaNotification();
                      cancelFajrNotification();
                      cancelDhuhrNotification();
                      cancelAsrNotification();
                      cancelMaghribNotification();
                    } else {
                      scheduleNotifications();
                    }
                  }
                },
                activeColor: TColors.primaryColor,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}