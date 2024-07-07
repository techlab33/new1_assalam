import 'dart:developer';

import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../data/models/prayer_time_models/prayer_time_data_model.dart';
import '../../data/services/prayer_times/prayer_time_get_data.dart';
import 'notification_provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final List<String> prayerNames = [
    'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  ];

  String? currentCity;
  String? currentCountry;
  PrayerTimeDataModel? prayerTimeDataModel;
  late DateTime dateTime;
  late String formattedDate;
  late String currentDate;
  final prayerTimeGetData = PrayerTimeGetData();

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
        fetchPrayerTimesAndScheduleNotifications();
      });
    } else {
      throw Exception("Something went wrong while fetching data.");
    }
  }

  Future<void> fetchPrayerTimesAndScheduleNotifications() async {
    try {
      final PrayerTimeDataModel? prayerTimeDataModel = await prayerTimeGetData.fetchPrayerTimeData(formattedDate, currentCity!, currentCountry!);
      if (prayerTimeDataModel != null && prayerTimeDataModel.data != null) {
        scheduleNotifications(prayerTimeDataModel);
        log('Prayer time fetch successfully');
      } else {
        print("Error: Prayer time data is null");
      }
    } catch (error) {
      print("Error fetching prayer times: $error");
    }
  }

  void scheduleNotifications(PrayerTimeDataModel prayerTimeDataModel) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    if (!notificationProvider.notificationsEnabled) {
      return;
    }

    final now = DateTime.now();
    final prayerTimes = {
      'Fajr': prayerTimeDataModel.data?.timings.fajr,
      'Dhuhr': prayerTimeDataModel.data?.timings.dhuhr,
      'Asr': prayerTimeDataModel.data?.timings.asr,
      'Maghrib': prayerTimeDataModel.data?.timings.maghrib,
      'Isha': prayerTimeDataModel.data?.timings.isha
    };

    final notificationSound = notificationProvider.selectedSound;

    prayerTimes.forEach((name, time) {
      if (time != null && notificationProvider.isNotificationEnabled(name)) {
        try {
          var scheduledTime = DateFormat("HH:mm").parse(time);
          var scheduledDate = DateTime(
            now.year,
            now.month,
            now.day,
            scheduledTime.hour,
            scheduledTime.minute,
          );

          if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(Duration(days: 1));
          }

          final notificationBody = posts.isNotEmpty ? posts[prayerNames.indexOf(name) % posts.length]['name'] as String : 'Prayer Time';

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
            prayerNames.indexOf(name), // Unique ID for the notification
            name, // Title
            notificationBody, // Body
            tz.TZDateTime.from(scheduledDate, tz.local), // Scheduled time
            platform,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e) {
          print("Error scheduling notification for $name: $e");
        }
      } else {
        print("Notification for $name is disabled or time is null");
      }
    });
  }

  void cancelNotification(String prayerName) {
    flutterLocalNotificationsPlugin.cancel(prayerNames.indexOf(prayerName));
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
                  fetchPrayerTimesAndScheduleNotifications();
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
                  if (value) {
                    fetchPrayerTimesAndScheduleNotifications();
                  } else {
                    cancelNotification(prayerName);
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