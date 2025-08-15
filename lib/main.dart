import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/models/asmr_data.dart';
import 'package:testapp/models/asmr_player_controller.dart';
import 'package:testapp/models/noti_service.dart';
import 'package:testapp/screens/home_page.dart';

Future<void> main() async {
  //휴대폰 알림
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotification();

  //알람 데이터 불러오기
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmDataAdapter());
  await Hive.openBox('alarm');
  alarmDataManagement.loadAlarmDataList();

  //사운드 테라피 오디오 키 불러오기
  Get.put(AsmrPlayerController());
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  //백그라운드 셋업
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BoDeepSleep App',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          surface: Color.fromARGB(0xff, 0x2a, 0x30, 0x36),
          surfaceDim: Color.fromARGB(0xff, 0x18, 0x17, 0x18),
          primary: Color.fromARGB(0xff, 0x67, 0xff, 0xaf),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromARGB(0xff, 0x18, 0x17, 0x18),
      ),
      home: const InitSplashScreen(),
    );
  }
}

class InitSplashScreen extends StatefulWidget {
  const InitSplashScreen({super.key});

  @override
  State<InitSplashScreen> createState() => _InitSplashScreenState();
}

class _InitSplashScreenState extends State<InitSplashScreen> {
  double _size = 250; // Get.size.width * 0.5

  @override
  void initState() {
    loadAsmrData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _size = 300; // Get.size.width * 0.7
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
            height: _size,
            width: _size,
            child: Image.asset(
              'assets/bodeepsleep_logo_beige.png',
              fit: BoxFit.contain,
            ),
            onEnd: () {
              Get.offAll(() => const MyHomePage());
            },
          ),
        ),
      ),
    );
  }
}
