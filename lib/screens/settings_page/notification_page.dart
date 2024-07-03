import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'notification_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  final List<String> prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playSound(String soundName) async {
    await audioPlayer.play(AssetSource('sounds/$soundName.wav'));
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF035408),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Select Notification Sound:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: notificationProvider.notificationSounds.map((sound) {
                  return RadioListTile<String>(
                    title: Text(sound),
                    value: sound,
                    groupValue: notificationProvider.selectedSound,
                    onChanged: (value) async {
                      await notificationProvider.setNotificationSound(value!);
                      playSound(value);
                    },
                    activeColor: Color(0xFF035408),
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
              },
              activeColor: Color(0xFF035408),
            ),
            SizedBox(height: 10),
            ...prayerNames.map((prayerName) {
              final isEnabled = notificationProvider.isNotificationEnabled(prayerName);
              return SwitchListTile(
                title: Text(prayerName),
                value: isEnabled,
                onChanged: (value) {
                  notificationProvider.toggleNotification(prayerName, value);
                },
                activeColor: Color(0xFF035408),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Refresh Location'),
              onPressed: () {
                notificationProvider.refreshLocation();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF035408)),
            ),
          ],
        ),
      ),
    );
  }
}