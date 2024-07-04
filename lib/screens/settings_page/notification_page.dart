import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'notification_provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final List<String> prayerNames = [
    'Imsak', 'Fajr', 'Sunrise', 'Dhuha', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  ];

  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlayingSound;

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
                  bool isPlaying = currentlyPlayingSound == sound;
                  return ListTile(
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
                    selectedTileColor: Colors.grey[200],
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
                if (!value) {
                  audioPlayer.pause();
                  setState(() {
                    currentlyPlayingSound = null;
                  });
                }
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
                  if (!value) {
                    audioPlayer.pause();
                    setState(() {
                      currentlyPlayingSound = null;
                    });
                  }
                },
                activeColor: Color(0xFF035408),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
