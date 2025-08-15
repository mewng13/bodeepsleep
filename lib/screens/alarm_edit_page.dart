// ignore_for_file: deprecated_member_use

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/models/alarm_controller.dart';
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/screens/alarm_page.dart';

class AlarmEditPage extends StatefulWidget {
  final AlarmData alarmData;

  const AlarmEditPage({super.key, required this.alarmData});

  @override
  State<AlarmEditPage> createState() => _AlarmEditPageState();
}

class _AlarmEditPageState extends State<AlarmEditPage> {
  late AlarmData tempAlarmData;
  bool isSoundSetting = false;
  bool isLightTimeSetting = false;

  final AssetsAudioPlayer _soundPlayer = AssetsAudioPlayer();
  final alarmController = Get.put(AlarmController());

  @override
  void initState() {
    super.initState();
    // 복사본 생성
    tempAlarmData = widget.alarmData.copyWith();

    //점점 밝아지는 시간 temporary index 설정
    int timeIndex = alarmController.alarmTimeNum.indexOf(
      tempAlarmData.ledBrightnessDration,
    );
    if (timeIndex == -1) {
      tempAlarmData.ledBrightnessDration = 30;
      timeIndex = 5;
      tempTimeIndex = timeIndex;
    }

    //알람 소리 temporary index 설정
    int soundIndex = alarmController.alarmSoundFiles.indexOf(
      tempAlarmData.alarmSoundUri,
    );
    if (soundIndex == -1) {
      tempAlarmData.alarmSoundUri = 'assets/alarmSound/Romantic_Melodic.wav';
      soundIndex = 0;
    }

    alarmController.selectedTimeIndex.value = timeIndex;
    alarmController.selectedSoundIndex.value = soundIndex;
  }

  //복사본 파일에 원본 덮어쓰기 (만약 완료를 누르지 않고 돌아간다면)
  Future<bool> _onWillPop() async {
    setState(() {
      tempAlarmData = widget.alarmData.copyWith();
    });
    return true;
  }

  //data에 집어넣을부분
  int _tempSoundIndex = 0;
  int tempTimeIndex = 0;

  @override
  Widget build(BuildContext context) {
    double columnPadding = 15;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('알람 수정', style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                // 완료 눌렀을 때 원본 업데이트
                alarmDataManagement.addAlarmData(tempAlarmData);
                Get.offAll(() => AlarmPage());
              },
              child: const Text(
                '완료',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        initialDateTime: tempAlarmData.time,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() {
                            tempAlarmData = tempAlarmData.copyWith(
                              time: newTime,
                            );
                          });
                        },
                        use24hFormat: false,
                        mode: CupertinoDatePickerMode.time,
                      ),
                    ),
                  ),
                  SizedBox(height: columnPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [Text('알람 반복')],
                  ),
                  SizedBox(height: columnPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      const dayLabels = ['월', '화', '수', '목', '금', '토', '일'];
                      return daysButton(context, dayLabels[index], index);
                    }),
                  ),
                  SizedBox(height: columnPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [Text('조명 최대 밝기')],
                  ),
                  SliderTheme(
                    data: const SliderThemeData(thumbColor: Colors.white),
                    child: Slider(
                      value: tempAlarmData.ledBrightness.toDouble(),
                      min: 0.0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          tempAlarmData = tempAlarmData.copyWith(
                            ledBrightness: value.toInt(),
                          );
                        });
                      },
                    ),
                  ),
                  SizedBox(height: columnPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('점점 밝아지는 시간'),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: CupertinoButton.filled(
                          onPressed: () {
                            alarmController
                                .selectedTimeIndex
                                .value = alarmController.alarmTimeNum.indexOf(
                              tempAlarmData.ledBrightnessDration,
                            );
                            tempTimeIndex =
                                alarmController.selectedTimeIndex.value;
                            showCupertinoModalPopup(
                              context: context,
                              builder:
                                  (_) => SizedBox(
                                    width: double.infinity,
                                    height: Get.height * 0.35,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: const Color.fromARGB(
                                            255,
                                            41,
                                            41,
                                            41,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  '취소',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '점점 밝아지는 시간',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    tempTimeIndex =
                                                        alarmController
                                                            .selectedTimeIndex
                                                            .toInt();
                                                    tempAlarmData =
                                                        tempAlarmData.copyWith(
                                                          ledBrightnessDration:
                                                              alarmController
                                                                  .alarmTimeNum[alarmController
                                                                  .selectedTimeIndex
                                                                  .toInt()],
                                                        );
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  '완료',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: CupertinoPicker(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  41,
                                                  41,
                                                  41,
                                                ),
                                            itemExtent: 50,
                                            scrollController:
                                                FixedExtentScrollController(
                                                  initialItem: tempTimeIndex,
                                                ),
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Text('1분 동안'),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Text('3분 동안'),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Text('5분 동안'),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Text('10분 동안'),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Text('20분 동안'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),

                                                    child: Text(
                                                      '기본',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text('30분 동안'),
                                                ],
                                              ),
                                            ],
                                            onSelectedItemChanged: (int value) {
                                              setState(() {
                                                alarmController
                                                    .selectedTimeIndex
                                                    .value = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          color: Theme.of(context).colorScheme.surfaceDim,
                          child: Text(
                            '${tempAlarmData.ledBrightnessDration}분 동안',

                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: columnPadding),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('알람 소리'),
                      OutlinedButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder:
                                (context) => Container(
                                  width: double.infinity,
                                  height: Get.size.height * 0.34,
                                  color: const Color.fromARGB(255, 41, 41, 41),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              _soundPlayer.stop();
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              '취소',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '알람 소리',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _soundPlayer.stop();
                                              setState(() {
                                                _tempSoundIndex =
                                                    alarmController
                                                        .selectedSoundIndex
                                                        .value;
                                                tempAlarmData = tempAlarmData
                                                    .copyWith(
                                                      alarmSoundUri:
                                                          alarmController
                                                              .alarmSoundFiles[_tempSoundIndex],
                                                    );
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              '완료',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Obx(
                                              () => Column(
                                                children: List.generate(
                                                  alarmController
                                                      .alarmSounds
                                                      .length,
                                                  (index) {
                                                    return ListTile(
                                                      title: Text(
                                                        alarmController
                                                            .alarmSounds[index],
                                                      ),
                                                      titleTextStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            alarmController
                                                                        .selectedSoundIndex
                                                                        .value ==
                                                                    index
                                                                ? Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary
                                                                : Colors.white,
                                                      ),
                                                      trailing:
                                                          alarmController
                                                                      .selectedSoundIndex
                                                                      .value ==
                                                                  index
                                                              ? Icon(
                                                                Icons.check,
                                                                color:
                                                                    Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .primary,
                                                              )
                                                              : null,
                                                      onTap: () {
                                                        _soundPlayer.stop();
                                                        if (index != 7) {
                                                          _soundPlayer.open(
                                                            Audio(
                                                              alarmController
                                                                  .alarmSoundFiles[index],
                                                            ),
                                                            autoStart: true,
                                                            showNotification:
                                                                false,
                                                          );
                                                        }
                                                        setState(() {
                                                          alarmController
                                                              .selectedSoundIndex
                                                              .value = index;
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ).then((_) {
                            _soundPlayer.stop();
                            alarmController
                                .selectedSoundIndex
                                .value = alarmController.alarmSoundFiles
                                .indexOf(tempAlarmData.alarmSoundUri);
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Text(
                          alarmController.alarmSounds[alarmController
                                  .alarmSoundFiles
                                  .contains(tempAlarmData.alarmSoundUri)
                              ? alarmController.alarmSoundFiles.indexOf(
                                tempAlarmData.alarmSoundUri,
                              )
                              : 0],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: columnPadding),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder:
                              (context) => CupertinoAlertDialog(
                                title: const Text("알람을 삭제 하시겠습니까?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("취소"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text(
                                      "삭제",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      alarmDataManagement.removeAlarmData(
                                        tempAlarmData.id,
                                      );
                                      Future.delayed(
                                        const Duration(milliseconds: 400),
                                        () {
                                          Get.offAll(
                                            () => const AlarmPage(),
                                            transition: Transition.leftToRight,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      ),
                      child: const Text(
                        '알람 삭제',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget daysButton(BuildContext context, String day, int index) {
    return Flexible(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            List<bool> newRepeatDay = List.from(tempAlarmData.repeatDay);
            newRepeatDay[index] = !newRepeatDay[index];
            tempAlarmData = tempAlarmData.copyWith(repeatDay: newRepeatDay);
          });
        },
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(
            width: 1,
            color:
                tempAlarmData.repeatDay[index]
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
          ),
          backgroundColor:
              tempAlarmData.repeatDay[index]
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          child: Text(
            day,
            style: TextStyle(
              color:
                  tempAlarmData.repeatDay[index]
                      ? Theme.of(context).colorScheme.surface
                      : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
