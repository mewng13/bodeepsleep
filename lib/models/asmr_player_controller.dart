import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:testapp/models/asmr_data.dart';
import 'package:testapp/models/noti_service.dart';

class AsmrPlayerController extends GetxController {
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId(
    'asmr_player',
  );
  final Rxn<AsmrData> currentData = Rxn<AsmrData>();
  final RxBool isPlaying = false.obs;
  final Rx<Duration> positionTime = Duration.zero.obs;
  final Rx<Duration> durationTime = Duration(seconds: 1).obs;
  final RxBool haveTimer = true.obs;
  final RxBool isDragging = false.obs;
  final RxDouble dragValue = 0.0.obs;
  var loopMode = LoopMode.none;

  final RxBool isInfinite = false.obs;
  final RxInt indexSelect = 3.obs;
  final RxString beforeSound = ''.obs;

  @override
  void onInit() {
    super.onInit();

    _audioPlayer.isPlaying.listen((event) {
      isPlaying.value = event;
    });

    _audioPlayer.currentPosition.listen((pos) {
      if (!isDragging.value) {
        positionTime.value = pos;
      }
    });

    _audioPlayer.current.listen((playing) {
      final dur = playing?.audio.duration;
      if (dur != null) {
        durationTime.value = dur;
      }
    });

    _audioPlayer.playlistAudioFinished.listen((_) async {
      final playing = await _audioPlayer.isPlaying.first;
      if (!playing) {
        isPlaying.value = false;
      }
    });
  }

  Future<void> play(AsmrData data) async {
    //이미 똑같은 것을 플레이하려고 한다면 state 유지
    if (currentData.value?.code == data.code) {
      return;
    }

    //다른 오디오라면 전 것을 멈추고 다른 오디오 시작
    await _audioPlayer.stop();
    currentData.value = data;

    if (data.ctg1 == '공간' || data.ctg1 == '음악') {
      isInfinite.value = true;
      haveTimer.value = true;
    } else {
      isInfinite.value = false;
      haveTimer.value = false;
    }
    loopMode = isInfinite.value ? LoopMode.single : LoopMode.none;

    await _audioPlayer.open(
      data.audio,
      showNotification: true,
      autoStart: true,
      loopMode: loopMode,
    );
  }

  void togglePlayPause() {
    _audioPlayer.playOrPause();
  }

  void stop() {
    _audioPlayer.stop();
    currentData.value = null;
  }

  void next(String selectedCtg2) {
    final current = currentData.value;
    if (current == null) return;

    final ctg2 = current.ctg2;
    final ctg1 = current.ctg1;
    final ctg1Sub = current.ctg1Sub;
    List<AsmrData>? list;

    if (selectedCtg2 == '전체') {
      final innerMap = asmrCtg1Datas['전체'];
      final rawList = innerMap?[ctg1];
      list = rawList?.where((e) => e.ctg1Sub == ctg1Sub).toList();
    } else {
      final innerMap = asmrCtg1Datas[ctg2];
      final rawList = innerMap?[ctg1];
      list = rawList?.where((e) => e.ctg1Sub == ctg1Sub).toList();
    }

    if (list == null || list.isEmpty) return;

    final index = list.indexWhere((e) => e.code == current.code);
    if (index != -1 && index < list.length - 1) {
      play(list[index + 1]);
    }
  }

  void previous(String selectedCtg2) {
    final current = currentData.value;
    if (current == null) return;

    final ctg2 = current.ctg2;
    final ctg1 = current.ctg1;
    final ctg1Sub = current.ctg1Sub;
    List<AsmrData>? list;

    if (selectedCtg2 == '전체') {
      final innerMap = asmrCtg1Datas['전체'];
      final rawList = innerMap?[ctg1];
      list = rawList?.where((e) => e.ctg1Sub == ctg1Sub).toList();
    } else {
      final innerMap = asmrCtg1Datas[ctg2];
      final rawList = innerMap?[ctg1];
      list = rawList?.where((e) => e.ctg1Sub == ctg1Sub).toList();
    }

    if (list == null || list.isEmpty) return;

    final index = list.indexWhere((e) => e.code == current.code);
    if (index > 0) {
      play(list[index - 1]);
    }
  }

  void seekTo(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }

  final RxInt remainingMinutes = 0.obs; // 남은 시간(초)
  Timer? _countdownTimer;
  final RxString previousCode = "".obs;

  void startCountdown(int minutes) {
    stopCountdown(); // 기존 타이머 있으면 취소
    remainingMinutes.value = minutes;

    _countdownTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (remainingMinutes.value > 0) {
        remainingMinutes.value--;
      } else {
        timer.cancel();
        _audioPlayer.stop(); // 음악 정지
        haveTimer.value = false;
        NotiService().showNotification(
          title: "Bodeepsleep",
          body: "사운드 테라피 반복이 종료되었습니다.",
        );
      }
    });
  }

  void stopCountdown() {
    _countdownTimer?.cancel();
    remainingMinutes.value = 0;
  }

  void setNewTimer(int selectedIndex) {
    stopCountdown();

    if (selectedIndex < 3) {
      final List<int> minutes = [30, 60, 120];
      startCountdown(minutes[selectedIndex]);
    } else {
      stopCountdown();
    }
  }

  AssetsAudioPlayer get player => _audioPlayer;
}
