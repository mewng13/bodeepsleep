// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/models/asmr_player_controller.dart';
import 'package:testapp/screens/asmr_info_page.dart';
import 'package:testapp/screens/asmr_repeat_page.dart';

class AsmrPlayPage extends StatelessWidget {
  final String selectedCtg2;
  AsmrPlayPage({super.key, required this.selectedCtg2});

  final AsmrPlayerController asmrPlayerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //현재 asmr 컨트롤러에서 플레이 중인 데이터 찾기
      final data = asmrPlayerController.currentData.value;

      //만일에 에러가 발생해 오디오가 재생되지 않는다면 표시
      if (data == null) {
        return const Scaffold(body: Center(child: Text("현재 재생중인 ASMR이 없습니다.")));
      }

      //오디오 시간 표기 format 설정
      String formatDuration(Duration duration) {
        final minutes = duration.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = duration.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        return "$minutes:$seconds";
      }

      String imagePath = 'assets/asmr/image/background/${data.code}.png';

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('사운드 테라피'),
        ),
        body: Stack(
          children: [
            SizedBox(
              width: Get.size.width,
              height: Get.size.height,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            if (data.narration)
              Positioned(
                top: Get.size.height * 0.1,
                left: Get.size.width / 2 - 100,
                child: const SizedBox(
                  width: 200,
                  child: Center(child: Text('NAR')),
                ),
              ),
            Positioned(
              top: Get.size.height * 0.1 + 30,
              left: 0,
              right: 0,
              child: SizedBox(
                width: 250,
                child: Center(
                  child: Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.size.height * 0.1 + 65,
              left: Get.size.width / 2 - 100,
              child: SizedBox(
                width: 200,
                child: Center(child: Text(data.ctg1Sub)),
              ),
            ),
            Positioned(
              bottom: Get.size.height * 0.38,
              left: 0,
              right: 0,
              child: Obx(() {
                return Center(
                  child: GestureDetector(
                    onTap: asmrPlayerController.togglePlayPause,
                    child: Image.asset(
                      asmrPlayerController.isPlaying.value
                          ? 'assets/pause.png'
                          : 'assets/play.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                );
              }),
            ),
            Positioned(
              bottom: Get.size.height * 0.38,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => asmrPlayerController.previous(selectedCtg2),
                    child: Padding(
                      padding: EdgeInsets.only(right: Get.size.width * 0.3),
                      child: Image.asset(
                        'assets/play_back.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => asmrPlayerController.next(selectedCtg2),
                    child: Padding(
                      padding: EdgeInsets.only(left: Get.size.width * 0.2),
                      child: Image.asset(
                        'assets/play_next.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (data.ctg1Sub == "ASMR" || data.ctg1Sub == "Music")
              Positioned(
                top: Get.size.height * 0.25,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => IconButton(
                            padding: EdgeInsets.zero,
                            icon: Image.asset(
                              asmrPlayerController.haveTimer.value
                                  ? "assets/timer_on.png"
                                  : "assets/timer.png",
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AsmrRepeatPage(
                                      imagePath: imagePath,
                                      code: data.code,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (data.ctg1Sub == "Music")
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            iconSize: 27,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AsmrInfoPage(
                                      imagePath: imagePath,
                                      code: data.code,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              )
            else
              Positioned(
                top: Get.size.height * 0.25,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          iconSize: 27,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AsmrInfoPage(
                                    imagePath: imagePath,
                                    code: data.code,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (data.ctg1 != "공간")
              Positioned(
                bottom: Get.size.height * 0.15,
                left: 30,
                right: 30,
                child: Obx(() {
                  final pos = asmrPlayerController.positionTime.value;
                  final dur = asmrPlayerController.durationTime.value;
                  final isDragging = asmrPlayerController.isDragging.value;
                  final dragValue = asmrPlayerController.dragValue.value;

                  final double sliderValue =
                      isDragging
                          ? dragValue.clamp(0, dur.inSeconds.toDouble())
                          : pos.inSeconds.toDouble().clamp(
                            0,
                            dur.inSeconds.toDouble(),
                          );

                  return Center(
                    child: SliderTheme(
                      data: const SliderThemeData(thumbColor: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              formatDuration(
                                Duration(seconds: sliderValue.toInt()),
                              ),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: dur.inSeconds.toDouble().clamp(
                                1,
                                double.infinity,
                              ),
                              value: sliderValue,
                              onChanged: (value) {
                                asmrPlayerController.isDragging.value = true;
                                asmrPlayerController.dragValue.value = value;
                              },
                              onChangeEnd: (value) {
                                final newPos = Duration(seconds: value.toInt());
                                asmrPlayerController.positionTime.value =
                                    newPos;
                                asmrPlayerController.isDragging.value = false;
                                asmrPlayerController.seekTo(
                                  Duration(seconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              formatDuration(dur),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
          ],
        ),
      );
    });
  }
}
