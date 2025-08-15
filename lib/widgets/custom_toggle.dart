
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:testapp/models/mood_status_controller.dart';


//토글 스위치
class CustomToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged? onToggleCallback;
  final double sizeRatio;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  const CustomToggle({
    super.key,
    required this.values,
    required this.onToggleCallback,
    this.sizeRatio = 1,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width * 0.6 * widget.sizeRatio,
        height: Get.width * 0.15 * widget.sizeRatio,
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: widget.onToggleCallback != null
                  ? () {
                      moodStatusController.colorTempIsWhite.value =
                          !moodStatusController.colorTempIsWhite.value;
                      var index = 0;
                      if (!moodStatusController.colorTempIsWhite.value) {
                        index = 1;
                      }
                      widget.onToggleCallback!(index);
                    }
                  : null,
              child: Container(
                width: Get.width * 0.6 * widget.sizeRatio,
                height: Get.width * 0.15 * widget.sizeRatio,
                decoration: ShapeDecoration(
                  color: widget.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    widget.values.length,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.05 * widget.sizeRatio),
                      child: Text(
                        widget.values[index],
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Get.width * 0.06 * widget.sizeRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xAA000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: moodStatusController.colorTempIsWhite.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: Get.width * 0.33 * widget.sizeRatio,
                height: Get.width * 0.15 * widget.sizeRatio,
                decoration: ShapeDecoration(
                  color: widget.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Get.width * 0.1 * widget.sizeRatio),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  moodStatusController.colorTempIsWhite.value
                      ? widget.values[0]
                      : widget.values[1],
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: Get.width * 0.06 * widget.sizeRatio,
                    color: widget.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
