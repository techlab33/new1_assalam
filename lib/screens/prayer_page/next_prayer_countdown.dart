
import 'dart:async';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/prayer_time_models/prayer_time_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';

class NextPrayerCountdown extends StatefulWidget {
  final PrayerTimeDataModel prayerTimeDataModel;

  const NextPrayerCountdown({required this.prayerTimeDataModel});

  @override
  _NextPrayerCountdownState createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<NextPrayerCountdown> {
  Timer? _timer;
  String nextPrayerName = '';
  String nextPrayerTime = '';
  String timeUntilNextPrayer = '';

  @override
  void initState() {
    super.initState();
    updateNextPrayerTime();
    startPrayerTimeUpdates();
    _updateTargetLanguage();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // =============> Prayer Time Data Start <==============

  void startPrayerTimeUpdates() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateNextPrayerTime();
    });
  }

  void updateNextPrayerTime() {
    final now = DateTime.now();
    final prayerTimings = widget.prayerTimeDataModel.data!.timings;
    final nextPrayer = getNextPrayer(now, prayerTimings);

    setState(() {
      nextPrayerName = nextPrayer['name']!;
      nextPrayerTime = nextPrayer['time']!;
      timeUntilNextPrayer = nextPrayer['duration']!;
    });
  }

  Map<String, String> getNextPrayer(DateTime now, Timings prayerTimings) {
    final Map<String, String> prayers = {
      'Fajr': prayerTimings.fajr,
      'Dhuhr': prayerTimings.dhuhr,
      'Asr': prayerTimings.asr,
      'Maghrib': prayerTimings.maghrib,
      'Isha': prayerTimings.isha,
    };

    for (var entry in prayers.entries) {
      final prayerTime = parseTime(entry.value);
      if (now.isBefore(prayerTime)) {
        final duration = prayerTime.difference(now);
        final hours = duration.inHours;
        final minutes = duration.inMinutes % 60;
        return {
          'name': entry.key,
          'time': DateFormat.jm().format(prayerTime), // Format time
          'duration': '$hours hours $minutes minutes',
        };
      }
    }

    // If no upcoming prayer, return the next day's Fajr
    final fajrTime = parseTime(prayers['Fajr']!).add(Duration(days: 1));
    final duration = fajrTime.difference(now);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return {
      'name': 'Fajr',
      'time': DateFormat.jm().format(fajrTime), // Format time
      'duration': '$hours hours $minutes minutes',
    };
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  // =============> Prayer Time Data End <==============

  // -------> Language Translator <--------
  final translator = GoogleTranslator();
  late String targetLanguage;

  void _updateTargetLanguage() {
    final languageController = Get.put(LanguageController());
    targetLanguage = languageController.language;
    languageController.languageStream.listen((language) {
      setState(() {
        targetLanguage = language;
      });
    });
  }
  // -------> Language Translator <--------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            // Image.asset('assets/icons/zuhr-sun-icon.png', height: 20, width: 20, color: Colors.white),
            SizedBox(width: 5),
            FutureBuilder<Translation>(
              future: translator.translate('$nextPrayerName, $nextPrayerTime', from: 'auto', to: targetLanguage),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final translatedText = snapshot.data!.text;
                  return Text(translatedText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox();
                }
              },
            ),

          ],
        ),
        SizedBox(height: 4),
        FutureBuilder<Translation>(
          future: translator.translate('$nextPrayerName prayer next\nin $timeUntilNextPrayer', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(translatedText, style: TextStyle(fontSize: targetLanguage == 'my' ? 11 : targetLanguage == 'km' ? 10 : targetLanguage == 'tl' ? 8 : 11, fontWeight: FontWeight.w500, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.right);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),

      ],
    );
  }
}