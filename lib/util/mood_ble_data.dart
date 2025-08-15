import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:testapp/models/mood_image_controller.dart';
import 'package:testapp/models/mood_status_controller.dart';
import 'package:testapp/util/constant.dart';

MoodBleData moodBleData = MoodBleData();

class MoodBleData {
  static StreamSubscription<List<int>>? streamSubscriptionMood;

  BluetoothCharacteristic? moodReadChr;
  BluetoothCharacteristic? moodWriteChr;
  BluetoothCharacteristic? moodNotifiChr;
  BluetoothCharacteristic? moodServiceChr;

  /// 무드등 응답의 타임아웃을 처리하기 위한 타이머
  Timer? bleReadTimeoutTimer;
  bool writeBleFlag = true;
  Function? waitingWritemood;
  int writeFuncCode = 0;
  Uint8List? additionalWriteData;
  Completer<void>? _pendingWrite;
  int? _latestFuncCode;
  List<int>? _latestData;

  /// 연결된 기기에 전송
  Future<void> writeMood(
    int funcCode,
    List<int> mood, {
    bool isFirst = true,
  }) async {
    // print('1 - $funcCode,$writeBleFlag,$isFirst');
    if (isFirst) {
      writeFuncCode = funcCode;
    }
    if (!writeBleFlag) {
      waitingWritemood = () {
        writeMood(funcCode, mood, isFirst: false);
      };
      if (bleReadTimeoutTimer != null) {
        bleReadTimeoutTimer!.cancel();
      }
      bleReadTimeoutTimer = Timer(Duration(seconds: 1), () {
        writeBleFlag = true;
        if (waitingWritemood != null) {
          waitingWritemood!();
          waitingWritemood = null;
        }
      });
      return;
    }
    try {
      if (null != moodWriteChr) {
        // print('2 - $funcCode,$writeBleFlag,$isFirst');
        writeBleFlag = false;

        final data = Uint8List(1 + 1 + mood.length);

        data[0] = funcCode;
        data[1] = data.length;
        data.setAll(2, mood.map((e) => e.toInt()));
        if (additionalWriteData != null) {
          Uint8List dataWithAdditional = Uint8List(
            data.length + additionalWriteData!.length,
          );
          dataWithAdditional.setAll(0, data);
          dataWithAdditional.setAll(data.length, additionalWriteData!);
          await moodWriteChr!.write(dataWithAdditional);
          additionalWriteData = null;
          debugPrint(
            "ble data write: ${dataWithAdditional.map((n) => n.toRadixString(16)).toList()}",
          );
        } else {
          await moodWriteChr!.write(data);
          debugPrint(
            "ble data write: ${data.map((n) => n.toRadixString(16)).toList()}",
          );
        }
      }
    } catch (e) {
      debugPrint('시스템 에 연결된 장치 오류 $e');
    } finally {
      writeBleFlag = true;
    }
  }

  //Slider 오류 방지용 writeMood()
  Future<void> writeMoodLatest(int funcCode, List<int> mood) async {
    _latestFuncCode = funcCode;
    _latestData = mood;

    // 이전 작업이 진행 중이면 끝날 때까지 기다리지 않고 무시
    if (_pendingWrite != null && !_pendingWrite!.isCompleted) {
      return;
    }

    // 새로운 요청 처리
    while (_latestFuncCode != null && _latestData != null) {
      final func = _latestFuncCode!;
      final data = _latestData!;
      _latestFuncCode = null;
      _latestData = null;

      _pendingWrite = Completer<void>();

      try {
        final packet = Uint8List(1 + 1 + data.length);
        packet[0] = func;
        packet[1] = packet.length;
        packet.setAll(2, data);
        await moodWriteChr!.write(packet);
        debugPrint(
          "ble data write: ${packet.map((n) => n.toRadixString(16)).toList()}",
        );
      } catch (e) {
        debugPrint("BLE write error: $e");
      } finally {
        _pendingWrite!.complete();
        _pendingWrite = null;
      }
    }
  }

  /// 연결된 무드등이 보내는 데이터 수신
  void readMoodNotifySetting() {
    try {
      if (null != moodReadChr) {
        // var moodStatus = await characteristic.read();
        // print(moodStatus);
        moodReadChr!.setNotifyValue(true).then((_) {
          if (streamSubscriptionMood != null) streamSubscriptionMood!.cancel();
          streamSubscriptionMood = moodReadChr!.lastValueStream.listen((value) {
            debugPrint(
              'data read: ${value.map((n) => n.toRadixString(16)).toList()}',
            );

            if (value.length < 2) return;
            switch (value[0]) {
              // RTC 데이터
              case 0x81:
                read0x81(value);
                break;
              // 후면등 데이터 전송
              case 0x82:
                read0x82(value);
                break;
              // 전면등 데이터 요청
              case 0x84:
                read0x84(value);
                break;

              // 후면등 데이터 전송
              case 0x83:
                read0x83(value);
                break;

              // 후면등 데이터 요청
              case 0x85:
                read0x85(value);
                break;
              // 무드등 꺼짐 예약 시간 전송
              case 0x86:
                read0x86(value);
                break;
              // 무드등 꺼짐 예약 시간 요청
              case 0x87:
                read0x87(value);
                break;
              // Alarm 시간 및 무드등 데이터 설정
              case 0x88:
                read0x88(value);
                break;
              // Alarm 시간 및 무드등 데이터 요청
              case 0x89:
                read0x89(value);
                break;
              // Alarm 종료
              case 0x8A:
                read0x8A(value);
                break;
              // Alarm 데이터 삭제 요청
              case 0x8B:
                read0x8B(value);
                break;
              // Mac Address 요청
              case 0x8C:
                read0x8C(value);
                break;
              //후면등 데이터 요청
              case 0x03:
                read0x03(value);

                break;
              // 전면등 데이터 요청
              case 0x02:
                read0x02(value);
                break;
            }
            if (!writeBleFlag) {
              writeBleFlag = true;
              if (bleReadTimeoutTimer != null) {
                bleReadTimeoutTimer!.cancel();
                if (waitingWritemood != null) {
                  waitingWritemood!();
                  waitingWritemood = null;
                }
              }
            }
          });
        });
      }
    } catch (e) {
      debugPrint('시스템 에 연결된 장치 오류 $e');
    }
  }

  void read0x02(List<int> value) {
    if (moodStatusController.minute15.value == true) {
      moodStatusController.minute15.value = false;
    } else if (moodStatusController.minute30.value == true) {
      moodStatusController.minute30.value = false;
    } else if (moodStatusController.minute60.value == true) {
      moodStatusController.minute60.value = false;
    }
    if (writeFrontFlag) {
      writeFront(isRead: true);
      return;
    }
    moodImageController.frontBrightness.value = value[3];
    moodImageController.frontColorTemp.value = value[2];
    moodImageController.frontOnOff.value = value[2] != 0;
    moodStatusController.frontBrightness.value = value[3];
    moodStatusController.frontSliderBrightness.value = value[3];
    if (value[2] != 0) {
      moodStatusController.frontColorTemp.value = value[2];
      moodStatusController.colorTempIsWhite.value = value[2] == 2;
    }
    moodStatusController.frontOnOff.value = value[2] != 0;

    moodImageController.changeImage();
  }

  void read0x03(List<int> value) {
    if (writeBackFlag) {
      writeBack(isRead: true);
      return;
    }
    moodImageController.backBrightness.value = value[3];
    moodImageController.backOnOff.value = value[2] != 0;
    moodStatusController.backBrightness.value = value[3];
    moodStatusController.backSliderBrightness.value = value[3];
    moodStatusController.backOnOff.value = value[2] != 0;
    moodImageController.changeImage();
  }

  void read0x85(List<int> value) {
    if (writeBackFlag) {
      writeBack(isRead: true);
      return;
    }
    moodImageController.backBrightness.value = value[3];
    moodImageController.backOnOff.value = value[2] != 0;
    moodStatusController.backBrightness.value = value[3];
    moodStatusController.backSliderBrightness.value = value[3];
    moodStatusController.backOnOff.value = value[2] != 0;
    moodImageController.changeImage();
  }

  void read0x83(List<int> value) {
    moodImageController.backBrightness.value = value[3];
    moodImageController.backOnOff.value = value[2] != 0;
    moodImageController.changeImage();
    moodStatusController.backBrightness.value = value[3];
    moodStatusController.backOnOff.value = value[2] != 0;
  }

  void read0x84(List<int> value) {
    if (writeFrontFlag) {
      writeFront(isRead: true);
      return;
    }
    moodImageController.frontBrightness.value = value[3];
    moodImageController.frontColorTemp.value = value[2];
    moodImageController.frontOnOff.value = value[2] != 0;
    moodStatusController.frontBrightness.value = value[3];
    moodStatusController.frontSliderBrightness.value = value[3];
    if (value[2] != 0) {
      moodStatusController.frontColorTemp.value = value[2];
      moodStatusController.colorTempIsWhite.value = value[2] == 2;
    }
    moodStatusController.frontOnOff.value = value[2] != 0;
    moodImageController.changeImage();
  }

  void read0x82(List<int> value) {
    moodImageController.frontBrightness.value = value[3];
    moodImageController.frontColorTemp.value = value[2];
    moodImageController.frontOnOff.value = value[2] != 0;
    moodStatusController.frontBrightness.value = value[3];
    if (value[2] != 0) {
      moodStatusController.frontColorTemp.value = value[2];
      moodStatusController.colorTempIsWhite.value = value[2] == 2;
    }
    moodStatusController.frontOnOff.value = value[2] != 0;
    moodImageController.changeImage();
  }

  bool writeFrontFlag = false;

  /// 전면등 전송 함수
  void writeFront({bool isRead = false}) {
    if (writeFrontFlag && !isRead) return;

    if (!isRead) {
      writeFrontFlag = true;
      writeMood(FUNC_CODE_GET_FRONT_LIGHT, []);
    } else {
      writeFrontFlag = false;
      writeMood(FUNC_CODE_SET_FRONT_LIGHT, [
        moodStatusController.frontOnOff.value
            ? moodStatusController.frontColorTemp.value
            : 0,
        moodStatusController.frontBrightness.value,
      ]);
    }
  }

  bool writeBackFlag = false;

  /// 후면등 전송 함수
  void writeBack({bool isRead = false}) {
    if (writeBackFlag && !isRead) return;
    if (!isRead) {
      writeBackFlag = true;
      writeMood(FUNC_CODE_GET_BACK_LIGHT, []);
    } else {
      writeBackFlag = false;
      writeMood(FUNC_CODE_SET_BACK_LIGHT, [
        moodStatusController.backOnOff.value ? 1 : 0,
        moodStatusController.backBrightness.value,
      ]);
    }
  }

  Future<void> shakeOnMood() async {
    //DartPluginRegistrant.ensureInitialized();

    bool onOffValue =
        moodStatusController.backOnOff.value ||
        moodStatusController.frontOnOff.value;
    moodStatusController.frontOnOff.value = !onOffValue;
    moodStatusController.backOnOff.value = !onOffValue;

    try {
      additionalWriteMood(FUNC_CODE_SET_FRONT_LIGHT, [
        moodStatusController.frontOnOff.value
            ? moodStatusController.frontColorTemp.value.toInt()
            : 0,
        moodStatusController.frontBrightness.value.toInt(),
      ]);
      await writeMood(FUNC_CODE_SET_BACK_LIGHT, [
        moodStatusController.backOnOff.value ? 1 : 0,
        moodStatusController.backBrightness.value.toInt(),
      ]);
    } catch (e) {
      debugPrint('시스템 에 연결된 장치 오류 $e');
    }
  }

  // 무드등 꺼짐 예약 시간 설정
  void offReserveMood({
    int year = 0,
    int month = 0,
    int day = 0,
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) async {
    DateTime now = DateTime.now();

    writeMood(FUNC_CODE_SET_CURRENT_RTC, [
      now.year - 2000,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ]);
    writeMood(FUNC_CODE_SET_SCHEDULED_OFF_TIME, [
      1,
      now.year - 2000 + year,
      now.month + month,
      now.day + day,
      now.hour + hour,
      now.minute + minute,
      now.second + second,
    ]);
  }

  void setMoodRtc() {
    DateTime now = DateTime.now();

    writeMood(FUNC_CODE_SET_CURRENT_RTC, [
      now.year - 2000,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ]);
  }

  void read0x81(List<int> value) {}

  void read0x86(List<int> value) {}

  void read0x87(List<int> value) {}

  void read0x88(List<int> value) {}

  void read0x89(List<int> value) {}

  void read0x8A(List<int> value) {}

  void read0x8B(List<int> value) {}

  void read0x8C(List<int> value) {}

  void additionalWriteMood(int funcCode, List<int> mood) {
    final data = Uint8List(1 + 1 + mood.length);

    data[0] = funcCode;
    data[1] = data.length;
    data.setAll(2, mood);

    additionalWriteData = data;
  }

  //무드등 꺼짐 예약 취소
  void cancelScheduledOffTime() {
    try {
      DateTime now = DateTime.now();

      writeMood(FUNC_CODE_SET_SCHEDULED_OFF_TIME, [
        0,
        now.year - 2000,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      ]);
    } catch (e) {
      debugPrint("무드등 예약 취소 실패: $e");
    }
  }
}
