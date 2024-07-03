import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/services/location_service/location_service.dart';
import 'package:assalam/screens/prayer_page/prayer_countdown.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:assalam/data/models/prayer_time_models/prayer_time_data_model.dart';
import 'package:assalam/data/services/prayer_times/prayer_time_get_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:tuple/tuple.dart';

class PrayerPage extends StatefulWidget {
  PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  String? currentCity;
  String? currentCountry;
  PrayerTimeDataModel? prayerTimeDataModel;
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String formattedDate2 = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String hijriFormattedCurrentDate = HijriCalendar.now().toFormat('dd MMMM yyyy');

  List<String> prayerNames = ['Imsak', 'Fajr', 'Sunrise', 'Dhuha', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  void initState() {
    fetchLocation();
    _updateTargetLanguage();
    initializeSharedPreferences();
    super.initState();
  }
  late SharedPreferences prefs;
  late DateTime lastColorChangeTime;
  final prayerTimeGetData = PrayerTimeGetData();

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    lastColorChangeTime = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lastColorChangeTime') ?? 0);
    setState(() {});
  }

  // Method to update the last color change time in shared preferences
  Future<void> updateLastColorChangeTime() async {
    lastColorChangeTime = DateTime.now();
    await prefs.setInt('lastColorChangeTime', lastColorChangeTime.millisecondsSinceEpoch);
  }

  // Method to check if 30 minutes have passed since the last color change
  bool shouldChangeColor(DateTime currentTime) {
    if (currentTime.difference(lastColorChangeTime).inMinutes >= 30) {
      return true;
    }
    return false;
  }

  DateTime getPrayerDateTime(String prayerTime) {
    final currentTime = DateTime.now();
    final prayerDateTime = DateFormat('HH:mm').parse(prayerTime, true);
    final prayerDateTimeToday = DateTime(currentTime.year, currentTime.month, currentTime.day, prayerDateTime.hour, prayerDateTime.minute);

    return prayerDateTimeToday;
  }

  Future<void> fetchLocation() async {
    await LocationService().requestPermissionAndFetchLocation();
    setState(() {
      currentCity = LocationService().currentCity;
      currentCountry = LocationService().currentCountry;
    });
    if (currentCity != null && currentCountry != null) {
      prayerTimeDataModel = await prayerTimeGetData.fetchPrayerTimeData(formattedDate2, currentCity!, currentCountry!);
      setState(() {});
    }
  }

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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.primaryColor,
        ),
        body: SafeArea(
            child: Container(
              height: screenSize.height,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(220, 213, 210, 1.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/flower-pattern-bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: screenSize.height / 3.42,
                        width: double.infinity,
                        color: TColors.primaryColor,
                        child: Column(
                          children: [
                            Image.asset('assets/logos/logo_assalam_hijau.png',
                                height: screenSize.height / 15.76),
                            SizedBox(height: 15),
                            currentCity != null && currentCountry != null &&
                                prayerTimeDataModel != null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder<Translation>(
                                  future: translator.translate(
                                      'Next Prayer', from: 'auto',
                                      to: targetLanguage),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final translatedText = snapshot.data!
                                          .text;
                                      return Text(translatedText,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                                SizedBox(height: 4),
                                PrayerCountdown(
                                    prayerTimeDataModel: prayerTimeDataModel!),
                              ],
                            )
                                : Center(
                                child: CircularProgressIndicator(color: Colors
                                    .white)),
                          ],
                        ),
                      ),
                      currentCity != null && currentCountry != null &&
                          prayerTimeDataModel != null
                          ? Center(
                        child: Container(
                          height: screenSize.height / 1.751,
                          width: screenSize.width / 1.161,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: screenSize.height / 4.147),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(236, 224, 217, 1.0),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          final formatter = DateFormat(
                                              'dd MMMM yyyy');
                                          final currentDate = formatter.parse(
                                              formattedDate);
                                          final previousDay = currentDate
                                              .subtract(Duration(days: 1));
                                          formattedDate =
                                              formatter.format(previousDay);
                                          formattedDate2 =
                                              DateFormat('dd-MM-yyyy').format(
                                                  previousDay);
                                          HijriCalendar hijriCalendar = HijriCalendar
                                              .fromDate(previousDay);
                                          hijriFormattedCurrentDate =
                                              hijriCalendar.toFormat(
                                                  'dd MMMM yyyy');
                                        });

                                        if (currentCity != null &&
                                            currentCountry != null) {
                                          prayerTimeDataModel =
                                          await prayerTimeGetData
                                              .fetchPrayerTimeData(
                                              formattedDate2, currentCity!,
                                              currentCountry!);
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(Icons.arrow_back_ios),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        FutureBuilder<Translation>(
                                          future: translator.translate(formattedDate, from: 'auto', to: targetLanguage),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final translatedText = snapshot
                                                  .data!.text;
                                              return Text(translatedText,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87));
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(height: 3),
                                        FutureBuilder<Translation>(
                                          future: translator.translate(
                                              hijriFormattedCurrentDate,
                                              from: 'auto', to: targetLanguage),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final translatedText = snapshot.data!.text;
                                              return Text(translatedText,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87));
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          final formatter = DateFormat('dd MMMM yyyy');
                                          final currentDate = formatter.parse(formattedDate);
                                          final nextDay = currentDate.add(Duration(days: 1));
                                          formattedDate = formatter.format(nextDay);
                                          formattedDate2 = DateFormat('dd-MM-yyyy').format(nextDay);
                                          HijriCalendar hijriCalendar = HijriCalendar.fromDate(nextDay);
                                          hijriFormattedCurrentDate = hijriCalendar.toFormat('dd MMMM yyyy');
                                        });

                                        if (currentCity != null &&
                                            currentCountry != null) {
                                          prayerTimeDataModel = await prayerTimeGetData.fetchPrayerTimeData(formattedDate2, currentCity!, currentCountry!);
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: prayerNames.length,
                                  itemBuilder: (context, index) {
                                    final prayerName = prayerNames[index];
                                    final prayerData = getPrayerTime(prayerName);
                                    final prayerDateTime = prayerData.item1;
                                    final formattedTime = prayerData.item2;

                                    final currentTime = DateTime.now();
                                    final isTimeToChangeColor = shouldChangeColor(currentTime);

                                    Color textColor = Colors.black; // Default text color

                                    // Determine the color based on prayer time and current time
                                    if (isTimeToChangeColor) {
                                      final prayerTime = getPrayerTime(prayerName);
                                      final currentTime = DateFormat('HH:mm').format(DateTime.now());

                                      switch (prayerName.toLowerCase()) {
                                        case 'imsak':
                                          final imsakTime = '03:49'; // Adjust this time as needed
                                          textColor = currentTime == imsakTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'fajr':
                                          final fajrTime = '03:59'; // Adjust this time as needed
                                          textColor = currentTime == fajrTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'sunrise':
                                          final sunriseTime = '05:11'; // Adjust this time as needed
                                          textColor = currentTime == sunriseTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'dhuha':
                                          final dhuhaTime = '05:39'; // Adjust this time as needed
                                          textColor = currentTime == dhuhaTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'dhuhr':
                                          final dhuhrTime = '11:58'; // Adjust this time as needed
                                          textColor = currentTime == dhuhrTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'asr':
                                          final asrTime = '15:17'; // Adjust this time as needed
                                          textColor = currentTime == asrTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'maghrib':
                                          final maghribTime = '18:50'; // Adjust this time as needed
                                          textColor = currentTime == maghribTime ? Colors.orange : Colors.black;
                                          break;
                                        case 'isha':
                                          final ishaTime = '19:57'; // Adjust this time as needed
                                          textColor = currentTime == ishaTime ? Colors.orange : Colors.black;
                                          break;
                                        default:
                                          textColor = Colors.blue; // Default color for other prayers
                                          break;
                                      }

                                      // If the color has changed, update the shared preferences
                                      if (textColor != Colors.black) {
                                        updateLastColorChangeTime();
                                      }
                                    }

                                    return ListTile(
                                      leading: Text(prayerName, style: TextStyle(color: textColor,fontSize: 15)),
                                      trailing: Text(formattedTime, style: TextStyle(color: textColor,fontSize: 15)),
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                      )
                          : Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: screenSize.height / 2.626),
                          child: CircularProgressIndicator(
                              color: TColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }

  Tuple2<DateTime, String> getPrayerTime(String prayerName) {
    late DateTime prayerDateTime;
    late String formattedTime;

    switch (prayerName) {
      case 'Imsak':
        formattedTime = prayerTimeDataModel!.data!.timings.imsak;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Fajr':
        formattedTime = prayerTimeDataModel!.data!.timings.fajr;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Sunrise':
        formattedTime = prayerTimeDataModel!.data!.timings.sunrise;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Dhuha':
        formattedTime = prayerTimeDataModel!.data!.timings.dhuha;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Dhuhr':
        formattedTime = prayerTimeDataModel!.data!.timings.dhuhr;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Asr':
        formattedTime = prayerTimeDataModel!.data!.timings.asr;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Maghrib':
        formattedTime = prayerTimeDataModel!.data!.timings.maghrib;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      case 'Isha':
        formattedTime = prayerTimeDataModel!.data!.timings.isha;
        prayerDateTime = getPrayerDateTime(formattedTime);
        break;
      default:
        formattedTime = '';
        prayerDateTime = DateTime.now();
        break;
    }
    return Tuple2(prayerDateTime, formattedTime);
  }
}


