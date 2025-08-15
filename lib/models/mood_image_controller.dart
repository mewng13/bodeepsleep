
import 'package:flutter/material.dart';
import 'package:get/get.dart';

MoodImageController moodImageController = Get.put(MoodImageController());

class MoodImageController extends GetxController {
  
  /// 전면등 색온도
  /// 0 = OFF, 1 = 3000K, 2 = 6500K
  Rx<int> frontColorTemp = 2.obs;

  /// 전면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> frontBrightness = 30.obs;

  /// 후면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> backBrightness = 20.obs;

  /// 전면등 온오프 상태
  Rx<bool> frontOnOff = false.obs;

  /// 후면등 온오프 상태
  Rx<bool> backOnOff = false.obs;

  final Rx<AssetImage> frontMoodImage =
      Rx<AssetImage>(const AssetImage('assets/light_front_off.png'));
  final Rx<AssetImage> backMoodImage =
      Rx<AssetImage>(const AssetImage('assets/light_back_off.png'));

  void changeImage() {
    if (frontColorTemp.value == 0 ||
        frontOnOff.value == false ||
        frontBrightness.value == 0) {
      frontMoodImage.value = const AssetImage('assets/light_front_off.png');
    } else if (frontColorTemp.value == 1) {
      switch ((frontBrightness.value / 3).floor()) {
        case 0:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_1.png');
          break;
        case 1:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_1.png');
          break;
        case 2:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_2.png');
          break;
        case 3:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_3.png');
          break;
        case 4:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_4.png');
          break;
        case 5:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_5.png');
          break;
        case 6:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_6.png');
          break;
        case 7:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_7.png');
          break;
        case 8:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_8.png');
          break;
        case 9:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_9.png');
          break;
        case 10:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_10.png');
          break;
        case 11:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_11.png');
          break;
        case 12:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_12.png');
          break;
        case 13:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_13.png');
          break;
        case 14:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_14.png');
          break;
        case 15:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_15.png');
          break;
        case 16:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_16.png');
          break;
        case 17:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_17.png');
          break;
        case 18:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_18.png');
          break;
        case 19:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_19.png');
          break;
        case 20:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_20.png');
          break;
        case 21:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_21.png');
          break;
        case 22:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_22.png');
          break;
        case 23:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_23.png');
          break;
        case 24:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_24.png');
          break;
        case 25:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_25.png');
          break;
        case 26:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_26.png');
          break;
        case 27:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_27.png');
          break;
        case 28:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_28.png');
          break;
        case 29:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_29.png');
          break;
        case 30:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_30.png');
          break;
        default:
          frontMoodImage.value =
              const AssetImage('assets/light_front_yellow_30.png');
      }
    } else if (frontColorTemp.value == 2) {
      switch ((frontBrightness.value / 3).floor()) {
        case 0:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_1.png');
          break;
        case 1:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_1.png');
          break;
        case 2:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_2.png');
          break;
        case 3:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_3.png');
          break;
        case 4:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_4.png');
          break;
        case 5:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_5.png');
          break;
        case 6:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_6.png');
          break;
        case 7:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_7.png');
          break;
        case 8:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_8.png');
          break;
        case 9:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_9.png');
          break;
        case 10:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_10.png');
          break;
        case 11:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_11.png');
          break;
        case 12:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_12.png');
          break;
        case 13:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_13.png');
          break;
        case 14:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_14.png');
          break;
        case 15:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_15.png');
          break;
        case 16:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_16.png');
          break;
        case 17:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_17.png');
          break;
        case 18:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_18.png');
          break;
        case 19:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_19.png');
          break;
        case 20:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_20.png');
          break;
        case 21:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_21.png');
          break;
        case 22:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_22.png');
          break;
        case 23:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_23.png');
          break;
        case 24:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_24.png');
          break;
        case 25:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_25.png');
          break;
        case 26:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_26.png');
          break;
        case 27:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_27.png');
          break;
        case 28:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_28.png');
          break;
        case 29:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_29.png');
          break;
        case 30:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_30.png');
          break;
        default:
          frontMoodImage.value =
              const AssetImage('assets/light_front_white_30.png');
      }
    }

    if (backBrightness.value == 0 || backOnOff.value == false) {
      backMoodImage.value = const AssetImage('assets/light_back_off.png');
    } else {
      // 후면등 이미지 밝기 지정 switch문
      switch ((backBrightness.value / 3).floor()) {
        case 0:
          backMoodImage.value = const AssetImage('assets/light_back_1.png');
          break;
        case 1:
          backMoodImage.value = const AssetImage('assets/light_back_1.png');
          break;
        case 2:
          backMoodImage.value = const AssetImage('assets/light_back_2.png');
          break;
        case 3:
          backMoodImage.value = const AssetImage('assets/light_back_3.png');
          break;
        case 4:
          backMoodImage.value = const AssetImage('assets/light_back_4.png');
          break;
        case 5:
          backMoodImage.value = const AssetImage('assets/light_back_5.png');
          break;
        case 6:
          backMoodImage.value = const AssetImage('assets/light_back_6.png');
          break;
        case 7:
          backMoodImage.value = const AssetImage('assets/light_back_7.png');
          break;
        case 8:
          backMoodImage.value = const AssetImage('assets/light_back_8.png');
          break;
        case 9:
          backMoodImage.value = const AssetImage('assets/light_back_9.png');
          break;
        case 10:
          backMoodImage.value = const AssetImage('assets/light_back_10.png');
          break;
        case 11:
          backMoodImage.value = const AssetImage('assets/light_back_11.png');
          break;
        case 12:
          backMoodImage.value = const AssetImage('assets/light_back_12.png');
          break;
        case 13:
          backMoodImage.value = const AssetImage('assets/light_back_13.png');
          break;
        case 14:
          backMoodImage.value = const AssetImage('assets/light_back_14.png');
          break;
        case 15:
          backMoodImage.value = const AssetImage('assets/light_back_15.png');
          break;
        case 16:
          backMoodImage.value = const AssetImage('assets/light_back_16.png');
          break;
        case 17:
          backMoodImage.value = const AssetImage('assets/light_back_17.png');
          break;
        case 18:
          backMoodImage.value = const AssetImage('assets/light_back_18.png');
          break;
        case 19:
          backMoodImage.value = const AssetImage('assets/light_back_19.png');
          break;
        case 20:
          backMoodImage.value = const AssetImage('assets/light_back_20.png');
          break;
        case 21:
          backMoodImage.value = const AssetImage('assets/light_back_21.png');
          break;
        case 22:
          backMoodImage.value = const AssetImage('assets/light_back_22.png');
          break;
        case 23:
          backMoodImage.value = const AssetImage('assets/light_back_23.png');
          break;
        case 24:
          backMoodImage.value = const AssetImage('assets/light_back_24.png');
          break;
        case 25:
          backMoodImage.value = const AssetImage('assets/light_back_25.png');
          break;
        case 26:
          backMoodImage.value = const AssetImage('assets/light_back_26.png');
          break;
        case 27:
          backMoodImage.value = const AssetImage('assets/light_back_27.png');
          break;
        case 28:
          backMoodImage.value = const AssetImage('assets/light_back_28.png');
          break;
        case 29:
          backMoodImage.value = const AssetImage('assets/light_back_29.png');
          break;
        case 30:
          backMoodImage.value = const AssetImage('assets/light_back_30.png');
          break;
        default:
          backMoodImage.value = const AssetImage('assets/light_back_30.png');
      }
    }
  }
}
