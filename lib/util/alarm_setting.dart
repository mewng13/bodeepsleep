import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testapp/main.dart';
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/util/mood_ble_data.dart';
import 'package:timezone/timezone.dart' as tz;

AlarmSetting alarmSetting = AlarmSetting();

final List<String> alarmSoundFiles = [
  'assets/alarmSound/Romantic_Melodic.wav',
  'assets/alarmSound/Claudio_the_worm.mp3',
  'assets/alarmSound/Morning_folk_song.mp3',
  'assets/alarmSound/Sand_castle.mp3',
  'assets/alarmSound/Ocean,_sea,_beace_ambience_with_seaguls.mp3',
  'assets/alarmSound/Emotional_piano.mp3',
  'assets/alarmSound/Chirping_birds.mp3',
  '',
];

final List<String> alarmSoundFiles_I = [
  'assets/alarmSound_I/Romantic_Melodic.aiff',
  'assets/alarmSound_I/Claudio_the_worm.aiff',
  'assets/alarmSound_I/Morning_folk_song.aiff',
  'assets/alarmSound_I/Sand_castle.aiff',
  'assets/alarmSound_I/Ocean,_sea,_beace_ambience_with_seaguls.aiff',
  'assets/alarmSound_I/Emotional_piano.aiff',
  'assets/alarmSound_I/Chirping_birds.aiff',
  '',
];

class AlarmSetting {
  // 앱 시작후 초기 연결시 앱의 알람값을 무드등에 전송
  void initSendMoodAlarm() {}
  Future<void> editMoodAlarm(AlarmData alarmData) async {
    moodBleData.setMoodRtc();

    // 알람을 무드등에 전송
    moodBleData.writeMood(0x08, alarmData.toMoodData());

    //알람 요일 notification
    await scheduleRepeatAlarms(alarmData);
  }

  Future<void> scheduleRepeatAlarms(AlarmData alarmData) async {
    // 기존 알람 제거 (겹치는 것 방지)
    await flutterLocalNotificationsPlugin.cancelAll();

    print('주간 핸드폰 알람이 설정되었습니다');
    // repeatday: [월,화,수,목,금,토,일] 형태라 가정
    for (int i = 0; i < alarmData.repeatDay.length; i++) {
      if (alarmData.repeatDay[i]) {
        int weekday = i + 1; // DateTime.monday = 1, ..., DateTime.sunday = 7

        await _scheduleWeeklyAlarm(
          weekday: weekday,
          dateTime: alarmData.time,
          id: weekday,
          soundFileNameAndroid: alarmData.alarmSoundUri,
          soundFileNameIOS:
              alarmSoundFiles_I[alarmSoundFiles.indexOf(
                alarmData.alarmSoundUri,
              )],
        );
      }
    }
  }

  Future<void> _scheduleWeeklyAlarm({
    required int weekday,
    required DateTime dateTime,
    required int id,
    String? soundFileNameAndroid,
    String? soundFileNameIOS,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // dateTime을 tz로 변환
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dateTime.hour,
      dateTime.minute,
    );

    // 오늘 시간이 이미 지났으면 다음 요일로
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'weekly_alarm_channel',
        '주간 알람',
        channelDescription: '요일 반복 알람',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Bodeepsleep',
      '설정된 알람이 울립니다!',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelAllAlarms() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('주간 핸드폰 알람이 취소되었습니다');
  }
}
