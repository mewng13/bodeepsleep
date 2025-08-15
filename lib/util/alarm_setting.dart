
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/util/mood_ble_data.dart';


AlarmSetting alarmSetting = AlarmSetting();

class AlarmSetting {
  // 앱 시작후 초기 연결시 앱의 알람값을 무드등에 전송
  void initSendMoodAlarm() {}
  void editMoodAlarm(AlarmData alarmData) {
    moodBleData.setMoodRtc();
    // 알람을 무드등에 전송
    moodBleData.writeMood(0x08, alarmData.toMoodData());
  }
}
