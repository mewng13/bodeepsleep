import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';

import 'package:testapp/models/mood_image_controller.dart';
import 'package:testapp/models/mood_status_controller.dart';
import 'package:testapp/models/noti_service.dart';
import 'package:testapp/screens/app_info_page.dart';
import 'package:testapp/util/mood_ble_connect.dart';
import 'package:testapp/util/mood_ble_data.dart';
import 'package:testapp/util/variable.dart';
import 'package:testapp/widgets/bottom_bar.dart';
import 'package:testapp/widgets/custom_toggle.dart';
import 'package:testapp/widgets/text_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    moodBleConnect.connectToMood();

    super.initState();
  }

  //종료 시간 값 리턴
  String calculateTime(int timerNum) {
    final now = DateTime.now();
    final later = now.add(Duration(minutes: timerNum));

    int hours = later.hour;
    int minutes = later.minute;
    int month = later.month;
    int date = later.day;
    bool am = true;

    if (hours > 12) {
      hours -= 12;
      am = false;
    }

    return "${"$month".padLeft(2, '0')}월 ${"$date".padLeft(2, "0")}일 ${am ? "오전" : "오후"} ${"$hours".padLeft(2, '0')}:${"$minutes".padLeft(2, '0')}에 꺼집니다.";
  }

  //휴대폰 알림 보내기
  Timer? timer;
  Future<void> phoneNoti(int time, Rx<bool> valueR) async {
    timer?.cancel();

    timer = Timer(Duration(minutes: time), () {
      NotiService().showNotification(
        title: "Bodeepsleep",
        body: "꺼짐 예약으로 LED가 OFF 됐습니다.",
      );
    });

    ever(valueR, (value) {
      timer?.cancel();
    });
  }

  int alarmTime = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Timer? debounceFront;
    Timer? debounceBack;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        centerTitle: true,
        title: const Text('스마트 컨트롤', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AppInfoPage();
                },
              ),
            );
          },
          icon: const Icon(Icons.info_outline, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (moodStatusController.connected.value) {
                moodBleConnect.disconnectToMood();
              } else {
                moodBleConnect.connectToMood();
              }
            },
            icon: const Icon(Icons.bluetooth, color: Colors.grey),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: SizedBox(
                      width: width * 0.9,
                      height: 44,
                      child: Center(
                        child: Obx(
                          () => Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              moodStatusController.connected.value
                                  ? '제품 이미지를 눌러 조명을 켜고 끌 수 있습니다'
                                  : '제품이 연결되지 않았습니다. 블루투스 연결을 확인해주세요.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap:
                              moodStatusController.connected.value
                                  ? () {
                                    setState(() {
                                      moodStatusController.frontOnOff.value =
                                          !moodStatusController
                                              .frontOnOff
                                              .value;
                                    });
                                    if (moodStatusController.frontOnOff.value &&
                                        moodStatusController
                                                .frontBrightness
                                                .value ==
                                            0) {
                                      moodStatusController
                                          .frontBrightness
                                          .value = 1;
                                      moodStatusController
                                          .frontSliderBrightness
                                          .value = 1;
                                    }
                                    moodBleData.writeFront();
                                  }
                                  : null,
                          child: SizedBox(
                            width: width * 0.33,
                            child: Stack(
                              children: [
                                const Image(
                                  image: AssetImage(
                                    'assets/light_front_off.png',
                                  ),
                                ),
                                FadeInImage(
                                  placeholder: const AssetImage(
                                    'assets/light_front_off.png',
                                  ),
                                  image:
                                      moodImageController.frontMoodImage.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap:
                              moodStatusController.connected.value
                                  ? () {
                                    setState(() {
                                      moodStatusController.backOnOff.value =
                                          !moodStatusController.backOnOff.value;
                                    });
                                    if (moodStatusController.backOnOff.value &&
                                        moodStatusController
                                                .backBrightness
                                                .value ==
                                            0) {
                                      moodStatusController
                                          .backBrightness
                                          .value = 1;
                                      moodStatusController
                                          .backSliderBrightness
                                          .value = 1;
                                    }
                                    moodBleData.writeBack();
                                  }
                                  : null,
                          child: SizedBox(
                            width: width * 0.33,
                            child: Stack(
                              children: [
                                const Image(
                                  image: AssetImage(
                                    'assets/light_back_off.png',
                                  ),
                                ),
                                FadeInImage(
                                  placeholder: const AssetImage(
                                    'assets/light_back_off.png',
                                  ),
                                  image:
                                      moodImageController.backMoodImage.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textTile('전면등 조명 밝기'),
                  SizedBox(
                    width: width * 0.9,
                    child: Obx(
                      () => SliderTheme(
                        data: SliderThemeData(thumbColor: Colors.white),
                        child: Slider(
                          value:
                              moodStatusController.frontSliderBrightness.value
                                  .toDouble(),
                          min: 0.0,
                          max: 100.0,
                          onChanged:
                              moodStatusController.connected.value
                                  ? (value) {
                                    moodStatusController.frontBrightness.value =
                                        value.toInt();
                                    moodStatusController
                                        .frontSliderBrightness
                                        .value = value.toInt();

                                    //디바운스 타임을 설정해서 0.05초가 지나면 데이터를 전송하게 함 (stack overflow 방지)
                                    if (debounceFront?.isActive ?? false) {
                                      debounceFront!.cancel();
                                    }
                                    debounceFront = Timer(
                                      Duration(milliseconds: 5),
                                      () {
                                        moodBleData.writeMoodLatest(0x02, [
                                          moodStatusController.frontOnOff.value
                                              ? moodStatusController
                                                  .frontColorTemp
                                                  .value
                                              : 0,
                                          moodStatusController
                                              .frontBrightness
                                              .value,
                                        ]);
                                      },
                                    );
                                  }
                                  : null,
                        ),
                      ),
                    ),
                  ),
                  textTile(
                    '전면등 조명 색',
                    child: CustomToggle(
                      sizeRatio: 0.6,
                      values: const ['청백색', '주황색'],
                      onToggleCallback:
                          moodStatusController.connected.value
                              ? (value) {
                                //debugPrint(value);
                                if (value == 0) {
                                  moodStatusController.frontColorTemp.value = 2;
                                  moodBleData.writeFront();
                                }
                                if (value == 1) {
                                  moodStatusController.frontColorTemp.value = 1;
                                  moodBleData.writeFront();
                                }
                              }
                              : null,
                    ),
                  ),
                  textTile('후면등 조명 밝기'),
                  SizedBox(
                    width: width * 0.9,
                    child: Obx(
                      () => SliderTheme(
                        data: SliderThemeData(thumbColor: Colors.white),
                        child: Slider(
                          value:
                              moodStatusController.backSliderBrightness.value
                                  .toDouble(),
                          min: 0.0,
                          max: 100.0,
                          onChanged:
                              moodStatusController.connected.value
                                  ? (value) {
                                    moodStatusController.backBrightness.value =
                                        value.toInt();
                                    moodStatusController
                                        .backSliderBrightness
                                        .value = value.toInt();

                                    //디바운스 타임을 설정해서 0.05초가 지나면 데이터를 전송하게 함 (stack overflow 방지)
                                    if (debounceBack?.isActive ?? false) {
                                      debounceBack!.cancel();
                                    }
                                    debounceBack = Timer(
                                      Duration(milliseconds: 5),
                                      () {
                                        moodBleData.writeMoodLatest(0x03, [
                                          moodStatusController.backOnOff.value
                                              ? 1
                                              : 0,
                                          moodStatusController
                                              .backBrightness
                                              .value,
                                        ]);
                                      },
                                    );
                                  }
                                  : null,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Divider(color: Colors.grey, thickness: 0.3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textTile('꺼짐 예약'),
                      Obx(
                        () => Opacity(
                          opacity:
                              moodStatusController.minute15.value
                                  ? 1.0
                                  : (moodStatusController.minute30.value
                                      ? 1.0
                                      : (moodStatusController.minute60.value
                                          ? 1.0
                                          : 0.0)),
                          child: Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.05),
                            child: Text(
                              calculateTime(alarmTime),
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() {
                        return OutlinedButton(
                          onPressed: () {
                            alarmTime = 15;
                            moodBleData.cancelScheduledOffTime();
                            if (moodStatusController.minute15.value == true) {
                              moodStatusController.minute15.value = false;
                            } else {
                              moodStatusController.minute15.value = true;
                              moodStatusController.minute30.value = false;
                              moodStatusController.minute60.value = false;
                              moodBleData.offReserveMood(minute: 15);

                              phoneNoti(15, moodStatusController.minute15);
                            }
                          },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color:
                                  moodStatusController.minute15.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            backgroundColor:
                                moodStatusController.minute15.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                          ),
                          child: Text(
                            '15분 뒤',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  moodStatusController.minute15.value
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        );
                      }),
                      Obx(
                        () => OutlinedButton(
                          onPressed: () {
                            alarmTime = 30;
                            moodBleData.cancelScheduledOffTime();
                            if (moodStatusController.minute30.value == true) {
                              moodStatusController.minute30.value = false;
                            } else {
                              moodStatusController.minute15.value = false;
                              moodStatusController.minute30.value = true;
                              moodStatusController.minute60.value = false;
                              moodBleData.offReserveMood(minute: 1);

                              phoneNoti(1, moodStatusController.minute30);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color:
                                  moodStatusController.minute30.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            backgroundColor:
                                moodStatusController.minute30.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                          ),
                          child: Text(
                            '30분 뒤',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  moodStatusController.minute30.value
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => OutlinedButton(
                          onPressed: () {
                            alarmTime = 60;
                            moodBleData.cancelScheduledOffTime();
                            if (moodStatusController.minute60.value == true) {
                              moodStatusController.minute60.value = false;
                            } else {
                              moodStatusController.minute15.value = false;
                              moodStatusController.minute30.value = false;
                              moodStatusController.minute60.value = true;

                              moodBleData.offReserveMood(minute: 60);
                              phoneNoti(60, moodStatusController.minute60);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color:
                                  moodStatusController.minute60.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            backgroundColor:
                                moodStatusController.minute60.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                          ),
                          child: Text(
                            '60분 뒤',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  moodStatusController.minute60.value
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Opacity(
                      opacity:
                          moodStatusController.minute15.value
                              ? 1.0
                              : (moodStatusController.minute30.value
                                  ? 1.0
                                  : (moodStatusController.minute60.value
                                      ? 1.0
                                      : 0.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.05),
                          ),
                          Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                            size: 20,
                          ),
                          Text(
                            ' 꺼짐 예약 기능이 활성화 되어 있습니다',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '모션제어',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(
                            width: width * 0.7,
                            child: const Text(
                              '스마트폰을 흔들어 제품을 끄고 킬 수 있습니다.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Obx(
                        () => Switch(
                          value: moodStatusController.shakeEnabled.value,
                          onChanged:
                              moodStatusController.connected.value
                                  ? (value) {
                                    setState(() {
                                      moodStatusController.shakeEnabled.value =
                                          value;
                                    });
                                    if (value) {
                                      //기존 인스턴스 감지기 종료
                                      shake?.stopListening();

                                      //움직임 스캔 시작 (새 감지기 생성)
                                      shake = ShakeDetector.autoStart(
                                        shakeThresholdGravity: 2.5,
                                        onPhoneShake: (ShakeEvent event) async {
                                          await moodBleData.shakeOnMood();
                                        },
                                      );
                                    } else {
                                      shake?.stopListening();
                                    }
                                  }
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 170),
                ],
              ),
            ),
            MediaQuery.of(context).size.height > 800
                ? BottomBar(bottom: MediaQuery.of(context).size.height / 12)
                : BottomBar(),
          ],
        ),
      ),
    );
  }
}
