
import 'package:assalam/controller/auth_controller/login_controller.dart';
import 'package:assalam/screens/authentication/registration_page/registration_page.dart';
import 'package:assalam/screens/bottom_nav_bar_page/bottom_nav_bar.dart';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/screens/settings_page/notification_page.dart';
import 'package:assalam/screens/settings_page/notification_provider.dart';
import 'package:assalam/utils/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "ASSALAM",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.High,
    shouldRequestBatteryOptimizationsOff: true,
    notificationIcon: AndroidResource(name: 'notification_icon', defType: 'drawable'),
  );
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application widgets for.

  final loginController = Get.put(LoginController());

  @override
  void initState() {
    loginController.isUserLogin().then((value) => {
      if(value == true){
        Get.offAll(const BottomNaveBarPage()),
      }else  {
        Get.offAll(const RegistrationPage()),
      }
    });
    //
    final languageController = Get.put(LanguageController());

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // navigatorKey: ContextUtility.navigatorKey,
      title: 'Assalam',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.appThemes,
      home: const RegistrationPage(),
      routes: {
        '/settings': (context) => NotificationSettingsPage(),
      },
    );
  }
}
