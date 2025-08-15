import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testapp/models/alarm_data.dart';
import 'package:testapp/models/mood_status_controller.dart';
import 'package:testapp/screens/alarm_add_page.dart';
import 'package:testapp/screens/alarm_edit_page.dart';
import 'package:testapp/screens/app_info_page.dart';
import 'package:testapp/util/alarm_setting.dart';
import 'package:testapp/util/mood_ble_connect.dart';
import 'package:testapp/util/mood_ble_data.dart';
import 'package:testapp/widgets/bottom_bar.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  bool sleepAlarm = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('알람', style: TextStyle(fontSize: 18)),
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
      body: Stack(
        children: [
          if (alarmDataList.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/group_4450.png', width: Get.width * 0.5),
                  SizedBox(height: Get.height * 0.03),
                  const Text(
                    '설정된 알람이 없습니다.\n추가 아이콘을 탭하여 알람을 추가해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Get.height * 0.2),
                ],
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: Get.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '자야 할 시간 알림',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(
                            width: Get.width * 0.7,
                            child: const Text(
                              '기상 알람 7시간 30분 전 자동으로 꺼집니다.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Switch(
                        value: sleepAlarm,
                        onChanged: (value) {
                          setState(() {
                            sleepAlarm = value;
                          });

                          if (value) {}
                        },
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          itemBuilder: (context, index) {
                            if (index == alarmDataList.length) {
                              return Row(
                                children: [
                                  SizedBox(width: Get.width * 0.05),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 7),
                                      Text(
                                        '* 알람은 1개만 활성화 할 수 있습니다.',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            78,
                                            78,
                                            78,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return alarmItem(context, index);
                            }
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: const Color.fromARGB(255, 78, 78, 78),
                              thickness: 0.5,
                              height: 3,
                              indent: 20,
                              endIndent: 20,
                            );
                          },
                          itemCount: alarmDataList.length + 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),

                        SizedBox(height: Get.height * 0.15),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          Positioned(
            bottom:
                MediaQuery.of(context).size.height > 800
                    ? 70 + MediaQuery.of(context).size.height / 12
                    : 90,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (alarmDataList.length == 5) {
                  showCupertinoDialog(
                    context: context,
                    builder: createFiveLimitDialog,
                  );
                } else {
                  Get.to(() => AlarmAddPage());
                }
              },
              child: const Icon(Icons.add, color: Colors.black, size: 25),
            ),
          ),
          MediaQuery.of(context).size.height > 800
              ? BottomBar(bottom: MediaQuery.of(context).size.height / 12)
              : BottomBar(),
        ],
      ),
    );
  }

  Widget createFiveLimitDialog(BuildContext context) => CupertinoAlertDialog(
    title: Text('알람은 5개까지만\n저장할 수 있습니다'),
    actions: [
      CupertinoDialogAction(
        child: Text('확인'),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );

  Widget alarmItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AlarmEditPage(alarmData: alarmDataList[index]));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text(
                      DateFormat("aa hh:mm").format(alarmDataList[index].time),
                      style: const TextStyle(fontSize: 23, color: Colors.white),
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: alarmDataList[index].on,
                      onChanged: (value) {
                        if (value) {
                          // 켜려고 할 때 이미 다른 알람이 켜져 있다면 경고 다이얼로그
                          final isAnotherOn = alarmDataList.any(
                            (alarm) =>
                                alarm.on && alarm != alarmDataList[index],
                          );

                          if (isAnotherOn) {
                            showCupertinoDialog(
                              context: context,
                              builder:
                                  (context) => CupertinoAlertDialog(
                                    title: const Text(
                                      "알람은 1개만 켤 수 있습니다.\n다른 알람을 먼저 끄세요.",
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("확인"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                            );
                            return;
                          } else if (alarmDataList[index].repeatDay.every(
                            (listValue) => !listValue,
                          )) {
                            showCupertinoDialog(
                              context: context,
                              builder:
                                  (context) => CupertinoAlertDialog(
                                    title: const Text("요일이 활성화되어 있어야 합니다."),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("확인"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                            );
                            return;
                          }

                          // Switch가 true인 경우 (알람 데이터 기기 전송)
                          setState(() {
                            alarmDataList[index].on = true;
                            alarmSetting.editMoodAlarm(alarmDataList[index]);
                          });
                        } else {
                          // 끄는 건 항상 허용
                          setState(() {
                            alarmDataList[index].on = false;
                            moodBleData.writeMood(0x0B, []);
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                newMethod(index, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row newMethod(int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        daysButton(index, 0, '월', context),
        daysButton(index, 1, '화', context),
        daysButton(index, 2, '수', context),
        daysButton(index, 3, '목', context),
        daysButton(index, 4, '금', context),
        daysButton(index, 5, '토', context),
        daysButton(index, 6, '일', context),
      ],
    );
  }

  Flexible daysButton(
    int dataIndex,
    int dayIndex,
    String day,
    BuildContext context,
  ) {
    return Flexible(
      child: OutlinedButton(
        onPressed: () {
          Get.to(() => AlarmEditPage(alarmData: alarmDataList[dataIndex]));
        },
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          side: BorderSide(
            width: 1,
            color:
                alarmDataList[dataIndex].repeatDay[dayIndex]
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
          ),
          backgroundColor:
              alarmDataList[dataIndex].repeatDay[dayIndex]
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          padding: EdgeInsets.all(0),
        ),
        child: SizedBox(
          child: Text(
            day,
            style: TextStyle(
              color:
                  alarmDataList[dataIndex].repeatDay[dayIndex]
                      ? Theme.of(context).colorScheme.surface
                      : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
