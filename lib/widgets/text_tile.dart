
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textTile(String text, {Widget? child}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: Get.width * 0.05),
      Text(text, style: const TextStyle(fontSize: 15, color: Colors.white)),
      child == null ? Container() : Expanded(child: Container()),
      child ?? Container(),
    ],
  );
}