// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
//
// import 'notification_provider.dart';
//
// class NewNotificationPage extends StatefulWidget {
//   const NewNotificationPage({super.key});
//
//   @override
//   State<NewNotificationPage> createState() => _NewNotificationPageState();
// }
//
// class _NewNotificationPageState extends State<NewNotificationPage> {
//
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   List<dynamic> posts = [];
//
//   void initNotifications() {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
//
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     const android = AndroidInitializationSettings('@drawable/notification_icon');
//     const initializationSettings = InitializationSettings(android: android);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//   }
//
//   Future<void> requestNotificationPermission() async {
//     PermissionStatus status = await Permission.notification.request();
//
//     if (status == PermissionStatus.granted) {
//       await downloadJson();
//       await downloadNotificationData();
//     } else {
//       print('Notification permission denied');
//     }
//   }
//
//   Future<void> downloadJson() async {
//     final response2 = await http.get(Uri.parse("https://assalam.icam.com.bd/public/api/prayerTime"));
//     if (response2.statusCode == 200) {
//       final data = json.decode(response2.body);
//
//       String date = '04-07-2024';
//       String city = 'Dhaka';
//       String country = 'Bangladesh';
//
//       // String date = data['date'];
//       // String city = data['city'];
//       // String country = data['country'];
//
//       final response = await http.get(Uri.parse("https://assalam.icam.com.bd/public/api/prayerTime/$date/$city/$country"));
//       if (response.statusCode == 200) {
//         final prayerData = json.decode(response.body);
//
//         List<Time> prayerTimes = [];
//         prayerTimes.add(_parseTime(prayerData['Fajr']));
//         prayerTimes.add(_parseTime(prayerData['Imsak']));
//         prayerTimes.add(_parseTime(prayerData['Dhuhr']));
//         prayerTimes.add(_parseTime(prayerData['Asr']));
//         prayerTimes.add(_parseTime(prayerData['Maghrib']));
//         prayerTimes.add(_parseTime(prayerData['Isha']));
//
//         setState(() {
//           scheduleNotification(prayerTimes);
//         });
//       } else {
//         throw Exception("Something went wrong while fetching data.");
//       }
//     } else {
//       throw Exception("Something went wrong while fetching data.");
//     }
//   }
//
//   Future<void> downloadNotificationData() async {
//     final response = await http.get(Uri.parse("https://raw.githubusercontent.com/techlab33/nubtk/main/new.json"));
//     if (response.statusCode == 200) {
//       setState(() {
//         posts = json.decode(response.body);
//       });
//     } else {
//       throw Exception("Something went wrong while fetching data.");
//     }
//   }
//
//   Time _parseTime(String timeStr) {
//     final parts = timeStr.split(':');
//     return Time(int.parse(parts[0]), int.parse(parts[1]), 0);
//   }
//
//   Future<void> scheduleNotification(List<Time> scheduledTimes) async {
//     final now = DateTime.now();
//     final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
//     if (!notificationProvider.notificationsEnabled) {
//       return;
//     }
//
//     for (int j = 0; j < scheduledTimes.length; j++) {
//       var scheduledDate = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         scheduledTimes[j].hour,
//         scheduledTimes[j].minute,
//         scheduledTimes[j].second,
//       );
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(Duration(days: 1));
//       }
//
//       final notificationBody = posts.isNotEmpty ? posts[j % posts.length]['name'] as String : 'It\'s time for prayer';
//       final notificationSound = notificationProvider.selectedSound;
//       final android = AndroidNotificationDetails(
//         'scheduled_notification',
//         'Scheduled Notifications',
//         channelDescription: 'This channel is used for scheduled notifications',
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound(notificationSound),
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//       final platform = NotificationDetails(android: android);
//
//       flutterLocalNotificationsPlugin.zonedSchedule(
//         j,
//         'ASSALAM',
//         notificationBody,
//         tz.TZDateTime.from(scheduledDate, tz.local),
//         platform,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }
// //==========//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initNotifications();
//     downloadJson();
//     downloadNotificationData();
//     requestNotificationPermission();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
