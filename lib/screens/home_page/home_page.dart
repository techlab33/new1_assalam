import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/prayer_time_models/prayer_time_data_model.dart';
import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/services/location_service/location_service.dart';
import 'package:assalam/data/services/prayer_times/prayer_time_get_data.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:assalam/screens/hadith_page/hadith_page.dart';
import 'package:assalam/screens/home_page/widgets/PremiumAlertDialogShow.dart';
import 'package:assalam/screens/home_page/widgets/gird_view_container_card.dart';
import 'package:assalam/screens/live_stream/live_stream.dart';
import 'package:assalam/screens/live_stream/macca_live.dart';
import 'package:assalam/screens/live_stream/medina_live.dart';
import 'package:assalam/screens/prayer_page/next_prayer_countdown.dart';
import 'package:assalam/screens/prayer_page/prayer_page.dart';
import 'package:assalam/screens/premium_page/premium_page.dart';
import 'package:assalam/screens/profile_page/profile_page.dart';
import 'package:assalam/screens/quran_page/quran_page.dart';
import 'package:assalam/screens/settings_page/notification_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AudioPlayer audioPlayer;

  bool _isPlaying = false;
  late SharedPreferences _prefs;

  //
  late DateTime dateTime;
  late String formattedDate;
  late String currentDate;

  String? currentCity;
  String? currentCountry;
  PrayerTimeDataModel? prayerTimeDataModel;


  //======start init state ===========//
  @override
  void initState() {
    super.initState();
    initializePlayer();
    fetchLocation();
    _checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    initNotifications();
    requestNotificationPermission();
    flutterLocalNotificationsPlugin;

    downloadJson();

    tz.initializeTimeZones();
    dateTime = DateTime.now();
    // Format the current date
    formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    currentDate = DateFormat('dd-mm-yyyy').format(dateTime);
    // Language
    _updateTargetLanguage();

  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _connectivity.onConnectivityChanged.drain();
    super.dispose();
  }

  //======end  init state ===========//

  // =============> Audio Player Start <==============
  Future<void> initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();
    bool? audioPlayed = _prefs.getBool('audioPlayed');
    if (audioPlayed == null || !audioPlayed) {
      audioPlayer = AudioPlayer();
      await playAudio();
      _prefs.setBool('audioPlayed', true);
    }
  }

  Future<void> playAudio() async {
    if (!_isPlaying) {
      await audioPlayer.play(AssetSource('bismillah.mp3'));
      setState(() {
        _isPlaying = true;
      });
    }
  }


  bool isFinished = false;

  //=============== Audio End =======//

  //============notification start==========//

  List<dynamic> posts = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
    final response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/techlab33/nubtk/main/new.json"));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
        scheduleNotification();
      });
    } else {
      throw Exception("Something went wrong while fetching data.");
    }
  }

  void scheduleNotification() {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    if (!notificationProvider.notificationsEnabled) {
      return;
    }

    final now = DateTime.now();
    final scheduledTimes = [
      Time(5, 3, 0),
      Time(11, 58, 0),
      Time(15, 20, 0),
      Time(17, 51, 0),//18.50
      Time(19, 51, 0),//19.52
    ];

    final notificationSound = notificationProvider.selectedSound;

    for (int j = 0; j < scheduledTimes.length; j++) {
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        scheduledTimes[j].hour,
        scheduledTimes[j].minute,
        scheduledTimes[j].second,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }

      final notificationBody = posts[j]['name'] as String;
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
        j,
        'ASSALAM',
        notificationBody,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platform,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

//====================notification end ==================//

  //===========internet checker start================//

  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  Future<void> _checkInitialConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
    });

    if (!_isConnected) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your network connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//=========== internet checker end ================//


  // =============> Prayer Time Data Start <==============
  final prayerTimeGetData = PrayerTimeGetData();

  // =============> Prayer Time Data End <==============

  // =============> Get User Current Location Start <==============
  Future<void> fetchLocation() async {
    await LocationService().requestPermissionAndFetchLocation();
    setState(() {
      currentCity = LocationService().currentCity;
      currentCountry = LocationService().currentCountry;
    });

    if (currentCity != null && currentCountry != null) {
      prayerTimeDataModel = await prayerTimeGetData.fetchPrayerTimeData(
          currentDate, currentCity!, currentCountry!);
      setState(() {});
    }
  }

  // =============> Get User Current Location End <==============

  // --------> User Profile Data <--------
  var fetchProfileData = UserProfileGetData();
  // --------> User Profile Data Get <--------

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
  List ? subscriptionType = [];



  @override
  Widget build(BuildContext context) {
    // Hijri date
    HijriCalendar _today = HijriCalendar.now();
    String hijriDate = _today.toFormat("dd MMMM yyyy");
    // Screen Size
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // -------------> New Design Start <-------------
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(239, 229, 223, 1),
              image: DecorationImage(
                image: AssetImage('assets/images/flower-pattern-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // -------->  Left & Right corner image  <---------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/left_corner.png'),
                    Image.asset('assets/images/right_corner.png'),
                  ],
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: screenSize.height / 78.8),
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/bismillah_arabic-removebg-preview.png', height: screenSize.height / 12.123, width: screenSize.width / 1.8),
                    ),
                  ],
                ),

                // ------>  Design  <---------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.height / 17.511, left: screenSize.width / 60),
                        height: screenSize.height / 1.06,
                        width: screenSize.width / 1.16,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/dome-design.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            // ------>  Assalam Logo  <---------
                            Container(
                              margin: EdgeInsets.only(top: screenSize.height / 9.85),
                              child: Image.asset(
                                  'assets/logos/logo_assalam_hijau.png',
                                  height: screenSize.height / 10.50,
                                  width: screenSize.width / 3.6),
                            ),

                            // ------>  Assalamualaikum Text User Name Text & User Image  <-------

                            FutureBuilder<UserProfileDataModel>(
                              future: fetchProfileData.fetchUserProfileData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(color: Colors.green));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data?.user == null) {
                                  return Text('No data available');
                                } else {
                                  final UserProfileDataModel userProfileDataModel = snapshot.data!;
                                  subscriptionType = userProfileDataModel.user?.subscriptionType;
                                  return Padding(
                                    padding: EdgeInsets.only(left: screenSize.width / 8),
                                    child: InkWell(
                                      onTap: () => Get.to(ProfilePage()),
                                      child: Row(
                                        children: [
                                          Container(
                                            //alignment: Alignment.center,
                                            width: screenSize.width / 2.117,
                                            child: FutureBuilder<Translation>(
                                              future: translator.translate('Assalamualaikum', from: 'auto', to: targetLanguage),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final translatedText = snapshot.data!.text;
                                                  return Text("$translatedText ${userProfileDataModel.user!.name ?? ''}", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),maxLines: 1, overflow: TextOverflow.ellipsis);
                                                } else if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(width: screenSize.width / 60),
                                          CircleAvatar(
                                            radius: 18,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: userProfileDataModel.user!.image ?? '',
                                                height: screenSize.height / 6.852,
                                                width: screenSize.width / 3.130,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
                                                errorWidget: (context, url, error) => Icon(Icons.person),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            SizedBox(height: screenSize.height / 131.333),

                            // ------> Subscription Banner Image  <-------
                            InkWell(
                              onTap: () => Get.to(PackageListScreen()),
                              child: Padding(
                                padding: EdgeInsets.only(right: screenSize.width / 72),
                                child: Container(
                                  height: screenSize.height / 12.25,
                                  width: screenSize.width / 1.333,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/get-more-features-banner-img.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height / 98.5),

                            // ------> Location & Prayer time & date  <-------
                            Padding(
                              padding: EdgeInsets.only(right: screenSize.width / 72),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenSize.width / 45, vertical: screenSize.height / 197),
                                height: screenSize.height / 8.56,
                                width: screenSize.width / 1.33,
                                color: Color.fromRGBO(5, 145, 5, 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // ------> Date time & Location  <-------
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<Translation>(
                                          future: translator.translate(formattedDate, from: 'auto', to: targetLanguage),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final translatedText = snapshot.data!.text;
                                              return Text(translatedText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,color: Colors.white));
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(height: screenSize.height / 262.66),
                                        FutureBuilder<Translation>(
                                          future: translator.translate(hijriDate, from: 'auto', to: targetLanguage),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final translatedText = snapshot.data!.text;
                                              return Text(translatedText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white));
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(height: screenSize.height / 157.6),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, size: 20, color: Colors.white),
                                            SizedBox(width: screenSize.width / 72),
                                            Text('$currentCity, \n$currentCountry', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12), maxLines: 2),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Divider Container
                                    Container(
                                      height: screenSize.height / 11.25,
                                      width: 1,
                                      color: Colors.white,
                                    ),

                                    // ------> Next Prayer And Time  <-------

                                    currentCity != null && currentCountry != null && prayerTimeDataModel != null ? Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              FutureBuilder<Translation>(
                                                future: translator.translate('Next Prayer', from: 'auto', to: targetLanguage),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final translatedText = snapshot.data!.text;
                                                    return Text(translatedText, style: TextStyle(fontSize: targetLanguage == 'tl' ? 11 : 13, fontWeight: FontWeight.w500, color: Colors.white));
                                                  } else if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                },
                                              ),
                                              // Text('Next Prayer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                                              SizedBox(height: screenSize.height / 197),
                                              NextPrayerCountdown(prayerTimeDataModel: prayerTimeDataModel!),
                                            ],
                                          )
                                        : Center(child: CircularProgressIndicator(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //  Home Page Items
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: screenSize.height / 1.8),
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: screenSize.width / 45,
                    mainAxisSpacing: screenSize.height / 98.5,
                    shrinkWrap: true,
                    childAspectRatio: .9,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GridViewContainerCard(
                        image: 'assets/images/prayer-time-icon.png',
                        text: 'Prayer Times',
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrayerPage())),
                      ),
                      GridViewContainerCard(
                        image: 'assets/images/quran-icon.png',
                        text: 'Quran',
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuranPage())),
                      ),
                      GridViewContainerCard(
                        image: 'assets/images/hadith-book-icon.png',
                        text: 'Hadith',
                        onPressed: () {
                          Get.to(HadithPage(),duration: Duration(milliseconds: 600));
                        },
                      ),
                      GridViewContainerCard(
                        image: 'assets/images/live-mecca-icon.png',
                        text: 'Live Mecca',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaccaLivePage()));
                        },
                      ),
                      GridViewContainerCard(
                        image: 'assets/images/live-medina-icon.png',
                        text: 'Live Medina',

                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MedinaLivePage()));
                        },
                      ),
                      GridViewContainerCard(
                        isPremium: true,
                        image: 'assets/images/live-assalam-icon.png',
                        text: 'Live Assalam',
                        onPressed: () {
                          subscriptionType == null ? showDialog(context: context, builder: (context) {
                            return PremiumAlertDialogShow(screenSize: screenSize);
                          }) : Get.to(LiveStreamPage());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // -------------> New Design End <-------------
        ),
      ),
    );
  }
}


