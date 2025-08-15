import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'alarm_data.g.dart';

List<AlarmData> alarmDataList = [];
AlarmDataManagement alarmDataManagement = AlarmDataManagement();

class AlarmDataManagement {
  Box alarmDataBox = Hive.box('alarm');
  void addAlarmData(AlarmData alarmData) {
    if (alarmDataList.length < alarmData.id) {
      alarmDataList.add(alarmData);
    } else {
      alarmDataList.removeWhere((element) => element.id == alarmData.id);
      alarmDataList.add(alarmData);
      alarmDataList.sort((a, b) => a.id.compareTo(b.id));
    }
    saveAlarmDataList();
  }

  void removeAlarmData(int alarmDataID) {
    alarmDataList.removeWhere((element) => element.id == alarmDataID);
    saveAlarmDataList();
  }

  void loadAlarmDataList() {
    try {
      alarmDataList = alarmDataBox.get('alarmData').cast<AlarmData>();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void saveAlarmDataList() {
    try {
      alarmDataBox.put('alarmData', alarmDataList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

@HiveType(typeId: 0)
class AlarmData extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int index;
  @HiveField(2)
  DateTime time;
  @HiveField(3)
  List<bool> repeatDay;
  @HiveField(4)
  bool on;
  @HiveField(5)
  int ledBrightness;
  @HiveField(6)
  int ledBrightnessDration;
  @HiveField(7)
  int insertedDate;
  @HiveField(8)
  String alarmSoundUri;
  @HiveField(9)
  int alarmSoundVolume = 30;

  AlarmData({
    required this.id,
    required this.index,
    required this.time,
    required this.repeatDay,
    required this.on,
    required this.ledBrightness,
    required this.ledBrightnessDration,
    required this.insertedDate,
    required this.alarmSoundUri,
    required this.alarmSoundVolume,
  });

  AlarmData copyWith({
    int? id,
    int? index,
    DateTime? time,
    List<bool>? repeatDay,
    bool? on,
    int? ledBrightness,
    int? ledBrightnessDration,
    int? insertedDate,
    String? alarmSoundUri,
    int? alarmSoundVolume,
  }) {
    return AlarmData(
      id: id ?? this.id,
      index: index ?? this.index,
      time: time ?? this.time,
      repeatDay:
          repeatDay != null ? List.from(repeatDay) : List.from(this.repeatDay),
      on: on ?? this.on,
      ledBrightness: ledBrightness ?? this.ledBrightness,
      ledBrightnessDration: ledBrightnessDration ?? this.ledBrightnessDration,
      insertedDate: insertedDate ?? this.insertedDate,
      alarmSoundUri: alarmSoundUri ?? this.alarmSoundUri,
      alarmSoundVolume: alarmSoundVolume ?? this.alarmSoundVolume,
    );
  }

  List<int> toMoodData() {
    int dI = id;
    int dYY = time.year - 2000;
    int dmm = time.month;
    int dDD = time.day;
    int dHH = time.hour;
    int dMM = time.minute;
    int dSS = time.second;
    int dL = ledBrightness;
    int dDR = ledBrightnessDration;
    int dD1 = repeatDay[6] ? 1 : 0; //일요일
    int dD2 = repeatDay[0] ? 1 : 0;
    int dD3 = repeatDay[1] ? 1 : 0;
    int dD4 = repeatDay[2] ? 1 : 0;
    int dD5 = repeatDay[3] ? 1 : 0;
    int dD6 = repeatDay[4] ? 1 : 0;
    int dD7 = repeatDay[5] ? 1 : 0;

    return [
      dI,
      dYY,
      dmm,
      dDD,
      dHH,
      dMM,
      dSS,
      dL,
      dDR,
      dD1,
      dD2,
      dD3,
      dD4,
      dD5,
      dD6,
      dD7,
    ];
  }

  // int getId() {
  //   return id;
  // }

  // void setId(int id) {
  //   this.id = id;
  // }

  // int getIndex() {
  //   return index;
  // }

  // void setIndex(int index) {
  //   this.index = index;
  // }

  // String getTime() {
  //   return time;
  // }

  // void setTime(String time) {
  //   this.time = time;
  // }

  // String getRepeatDay() {
  //   return repeatDay;
  // }

  // void setRepeatDay(String repeatDay) {
  //   this.repeatDay = repeatDay;
  // }

  // bool getOn() {
  //   return on;
  // }

  // void setOn(bool on) {
  //   this.on = on;
  // }

  // int getLedBrightness() {
  //   return ledBrightness;
  // }

  // void setLedBrightness(int ledBrightness) {
  //   this.ledBrightness = ledBrightness;
  // }

  // int getLedBrightnessDration() {
  //   return ledBrightnessDration;
  // }

  // void setLedBrightnessDration(int ledBrightnessDration) {
  //   this.ledBrightnessDration = ledBrightnessDration;
  // }

  // int getInsertedDate() {
  //   return insertedDate;
  // }

  // void setInsertedDate(int insertedDate) {
  //   this.insertedDate = insertedDate;
  // }

  // String getAlarmSoundUri() {
  //   return alarmSoundUri;
  // }

  // void setAlarmSoundUri(String alarmSoundUri) {
  //   this.alarmSoundUri = alarmSoundUri;
  // }

  // int getAlarmSoundVolume() {
  //   return alarmSoundVolume;
  // }

  // void setAlarmSoundVolume(int alarmSoundVolume) {
  //   this.alarmSoundVolume = alarmSoundVolume;
  // }
}
