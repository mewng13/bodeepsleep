// ignore_for_file: deprecated_member_use

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:testapp/models/asmr_player_controller.dart';

class AsmrRepeatPage extends StatefulWidget {
  final String imagePath, code;
  const AsmrRepeatPage({
    super.key,
    required this.imagePath,
    required this.code,
  });

  @override
  State<AsmrRepeatPage> createState() => _AsmrRepeatPageState();
}

class _AsmrRepeatPageState extends State<AsmrRepeatPage> {
  final AsmrPlayerController asmrPlayerController = Get.find();

  // 타이머 관련 상태
  int _selectedIndex = 3;
  bool changeAlarm = false;

  @override
  void initState() {
    super.initState();

    if (asmrPlayerController.previousCode.value == widget.code) {
      _selectedIndex = asmrPlayerController.indexSelect.value;
    } else {
      asmrPlayerController.stopCountdown();
      _selectedIndex = 3;
      asmrPlayerController.previousCode.value = '';

      if (widget.code == "공간") {
        asmrPlayerController.haveTimer.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          iconSize: 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('반복'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: Get.size.width,
              height: Get.size.height,
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),
            Positioned(
              top: Get.size.height * 0.16,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      changeAlarm ? "이 사운드를 얼마동안 재생할까요?" : "남은 시간",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "타이머는 하나만 설정가능합니다",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Get.size.height * 0.28,
              left: 0,
              right: 0,
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 3,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.size.height * 0.67,
              left: 50,
              right: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    asmrPlayerController.indexSelect.value = _selectedIndex;
                    changeAlarm = !changeAlarm;

                    if (!changeAlarm) {
                      asmrPlayerController.haveTimer.value = true;
                      asmrPlayerController.previousCode.value = widget.code;
                      if (_selectedIndex < 3) {
                        final List<int> minutes = [30, 60, 120];
                        asmrPlayerController.startCountdown(
                          minutes[_selectedIndex],
                        );
                      } else {
                        asmrPlayerController.stopCountdown();
                      }

                      if (!(asmrPlayerController.isPlaying.value)) {
                        asmrPlayerController.togglePlayPause();
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 60),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  changeAlarm ? "새로운 타이머 설정" : "설정된 타이머 삭제",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
            if (!changeAlarm)
              Positioned(
                top: Get.size.height * 0.43,
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(() {
                    final mins = asmrPlayerController.remainingMinutes.value;
                    if (_selectedIndex == 3) {
                      return Text("무한 반복", style: TextStyle(fontSize: 21.8));
                    }
                    return Text(
                      "${mins.toString()}분",
                      style: TextStyle(fontSize: 21.8),
                    );
                  }),
                ),
              ),
            if (changeAlarm)
              Positioned(
                top: Get.size.height * 0.33,
                left: 50,
                right: 50,
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: CupertinoPicker(
                    backgroundColor: Colors.black.withOpacity(0),
                    itemExtent: 50,
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedIndex,
                    ),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('30분'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('60분'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('120분'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('무한 반복'),
                      ),
                    ],
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
