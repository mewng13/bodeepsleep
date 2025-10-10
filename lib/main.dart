import 'dart:io' show Platform;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/models/asmr_data.dart';
import 'package:testapp/models/asmr_player_controller.dart';
import 'package:testapp/models/noti_service.dart';
import 'package:testapp/screens/home_page.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 백그라운드에서 실행할 콜백 (안드로이드 전용)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotiService().showNotification(
      title: "Bodeepsleep",
      body: "꺼짐 예약으로 LED가 OFF 됐습니다.",
    );
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  NotiService().initNotification();

  // Hive 초기화
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmDataAdapter());
  await Hive.openBox('alarm');
  alarmDataManagement.loadAlarmDataList();

  // ASMR 컨트롤러 등록
  Get.put(AsmrPlayerController());
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  // 로컬 알림 설정 (iOS / Android 공통)
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iOSSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ⚡ 플랫폼 분기 처리
  if (Platform.isAndroid) {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    await Workmanager().registerPeriodicTask(
      "periodic_notification_task",
      "periodic_notification_task",
      frequency: const Duration(minutes: 15), // 안드로이드는 최소 15분
    );
  }

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // 한국 기준

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
