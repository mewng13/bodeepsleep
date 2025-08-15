import 'package:get/get.dart';

MoodStatusController moodStatusController = Get.put(MoodStatusController());
final BeforeMoodStatus beforeMoodStatus = BeforeMoodStatus();

class MoodStatusController extends GetxController {
  Rx<bool> connected = false.obs;

  /// 전면등 색온도
  /// 0 = OFF, 1 = 3000K, 2 = 6500K
  Rx<int> frontColorTemp = 2.obs;

  /// 전면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> frontBrightness = 30.obs;

  /// 전면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> frontSliderBrightness = 30.obs;

  /// 후면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> backBrightness = 20.obs;

  /// 후면등 밝기
  /// 0x00 ~ 0x64
  Rx<int> backSliderBrightness = 20.obs;

  /// 전면등 온오프 상태
  Rx<bool> frontOnOff = false.obs;

  /// 후면등 온오프 상태
  Rx<bool> backOnOff = false.obs;

  void allOff() {
    connected.value = false;
    frontOnOff.value = false;
    backOnOff.value = false;

    // moodImageController.changeImage();
  }

  Rx<bool> minute15 = false.obs;
  Rx<bool> minute30 = false.obs;
  Rx<bool> minute60 = false.obs;
  Rx<bool> shakeEnabled = false.obs;

  Rx<bool> colorTempIsWhite = true.obs;
}

class BeforeMoodStatus {
  bool connected = false;

  /// 전면등 색온도
  /// 0 = OFF, 1 = 3000K, 2 = 6500K
  int frontColorTemp = 2;

  /// 전면등 밝기
  /// 0x00 ~ 0x64
  int frontBrightness = 30;

  /// 후면등 밝기
  /// 0x00 ~ 0x64
  int backBrightness = 20;

  /// 전면등 온오프 상태
  bool frontOnOff = false;

  /// 후면등 온오프 상태
  bool backOnOff = false;
}
