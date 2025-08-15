import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/screens/alarm_page.dart';
import 'package:testapp/screens/asmr_page.dart';
// import 'package:testapp/screens/asmr_page.dart';
import 'package:testapp/screens/home_page.dart';

final Image controlON = Image.asset(
  'assets/led_control_black.png',
  height: 35,
  width: 35,
);
final Image controlOFF = Image.asset(
  'assets/led_control_grey.png',
  height: 35,
  width: 35,
);
final Image alarmON = Image.asset(
  'assets/alarm_black.png',
  height: 35,
  width: 35,
);
final Image alarmOFF = Image.asset(
  'assets/alarm_grey.png',
  height: 35,
  width: 35,
);
final Image asmrON = Image.asset(
  'assets/asmr_black.png',
  height: 35,
  width: 35,
);
final Image asmrOFF = Image.asset(
  'assets/asmr_grey.png',
  height: 35,
  width: 35,
);

Image firstButton = controlON;
Image secondButton = alarmOFF;
Image thirdButton = asmrOFF;

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, this.bottom});

  final double? bottom;

  double bottomValue() {
    if (Platform.isAndroid) {
      return 20;
    }

    return bottom ?? 20;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomValue(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              color: Colors.white,
              width: 180,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (firstButton != controlON) {
                        firstButton = controlON;
                        secondButton = alarmOFF;
                        thirdButton = asmrOFF;
                        Get.offAll(
                          () => const MyHomePage(),
                          transition: Transition.noTransition,
                        );
                      }
                    },
                    icon: firstButton,
                  ),
                  IconButton(
                    onPressed: () {
                      if (secondButton != alarmON) {
                        firstButton = controlOFF;
                        secondButton = alarmON;
                        thirdButton = asmrOFF;
                        Get.offAll(
                          () => const AlarmPage(),
                          transition: Transition.noTransition,
                        );
                      }
                    },
                    icon: secondButton,
                  ),
                  IconButton(
                    onPressed: () {
                      if (thirdButton != asmrON) {
                        firstButton = controlOFF;
                        secondButton = alarmOFF;
                        thirdButton = asmrON;
                        Get.offAll(
                          () => const AsmrPage(),
                          transition: Transition.noTransition,
                        );
                      }
                    },
                    icon: thirdButton,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
