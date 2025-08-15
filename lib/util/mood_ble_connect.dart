// ignore_for_file: constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:testapp/models/mood_status_controller.dart';
import 'package:testapp/util/constant.dart';
import 'package:testapp/util/mood_ble_data.dart';

MoodBleConnect moodBleConnect = MoodBleConnect();

class MoodBleConnect {
  // static const BLE_MOOD_SERVICE_UUID = "9C187531-FEDA-4D42-A71D-2358B2BE1F43";
  // static const BLE_MOOD_READ_UUID = "9C187532-FEDA-4D42-A71D-2358B2BE1F43";
  // static const BLE_MOOD_NOTIFICATION_UUID =
  //     "9C187532-FEDA-4D42-A71D-2358B2BE1F43";
  // static const BLE_MOOD_WRITE_UUID = "9C187533-FEDA-4D42-A71D-2358B2BE1F43";

  static const BLE_MOOD_SERVICE_UUID = "0000FFF0-0000-1000-8000-00805F9B34FB";
  static const BLE_MOOD_READ_UUID = "0000FFF1-0000-1000-8000-00805F9B34FB";
  static const BLE_MOOD_NOTIFICATION_UUID =
      "0000FFF1-0000-1000-8000-00805F9B34FB";
  static const BLE_MOOD_WRITE_UUID = "0000FFF2-0000-1000-8000-00805F9B34FB";

  static StreamSubscription<List<ScanResult>>? streamConnectMood;

  BluetoothDevice? moodDevice;

  /// 무드등과 블루투스 연결
  /// return: 연결 성공 여부
  Future<void> connectToMood() async {
    // 무드등이 앱에 연결돼있으면 함수 종료
    if (moodStatusController.connected.value) return;
    // 휴대폰에 무드등이 페어링 돼있으면 연결후 함수 종료
    if (await checkSystemDevice()) return;

    if (await FlutterBluePlus.adapterState.first ==
        BluetoothAdapterState.unknown) {
      await Future.delayed(const Duration(seconds: 2));
    }
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    try {
      if (streamConnectMood != null) streamConnectMood!.cancel();

      final timeout = Future.delayed(const Duration(seconds: 20), () async {
        if (!moodStatusController.connected.value) {
          await FlutterBluePlus.stopScan();
          Fluttertoast.showToast(
            msg: "기기를 찾을 수 없습니다.",
            backgroundColor: const Color.fromARGB(230, 90, 90, 90),
          );
          debugPrint("기기 검색 타임아웃");
        }
      });

      streamConnectMood = FlutterBluePlus.scanResults.listen((results) async {
        if (!moodStatusController.connected.value) {
          for (ScanResult result in results) {
            debugPrint('${result.device.remoteId}');
            if (result.device.remoteId.toString() ==
                "EBA12637-7E13-CC9F-805D-6E7BA2F28500") {
              await FlutterBluePlus.stopScan();

              await Future.delayed(const Duration(milliseconds: 1200));
              await result.device.connect();
              moodDevice = result.device;
              moodStatusController.connected.value = result.device.isConnected;
              debugPrint('연결됨');
              for (BluetoothService service
                  in await result.device.discoverServices()) {
                for (BluetoothCharacteristic characteristic
                    in service.characteristics) {
                  if (characteristic.uuid == Guid(BLE_MOOD_NOTIFICATION_UUID)) {
                    moodBleData.moodNotifiChr = characteristic;
                  }
                  if (characteristic.uuid == Guid(BLE_MOOD_READ_UUID)) {
                    moodBleData.moodReadChr = characteristic;
                  }
                  if (characteristic.uuid == Guid(BLE_MOOD_SERVICE_UUID)) {
                    moodBleData.moodServiceChr = characteristic;
                  }
                  if (characteristic.uuid == Guid(BLE_MOOD_WRITE_UUID)) {
                    moodBleData.moodWriteChr = characteristic;
                  }
                }
              }
              moodBleData.readMoodNotifySetting();
              initConnectMood();
              Fluttertoast.showToast(
                msg: "기기와 연결 되었습니다.",
                backgroundColor: const Color.fromARGB(230, 90, 90, 90),
              );
              break;
            }
          }
        }
      });
      Fluttertoast.showToast(
        msg: "기기와 연결합니다. 잠시만 기다려주세요.",
        backgroundColor: const Color.fromARGB(230, 90, 90, 90),
      );

      await FlutterBluePlus.startScan(
        withServices: [Guid(BLE_MOOD_SERVICE_UUID)],
        timeout: const Duration(seconds: 35),
        continuousUpdates: true,
        continuousDivisor: Platform.isAndroid ? 8 : 1,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return;
  }

  void disconnectToMood() {
    Get.dialog(createBLEDialog());
    // Get.dialog(
    //   Dialog(
    //     alignment: Alignment.bottomCenter,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //     child: SizedBox(
    //       height: Get.size.height * 0.15,
    //       child: Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const Text('기기와 연결을 종료하시겠습니까?', style: TextStyle(fontSize: 17)),
    //             const SizedBox(height: 5),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 TextButton(
    //                   onPressed: () {
    //                     Get.back();
    //                   },
    //                   child: const Text('취소'),
    //                 ),
    //                 const SizedBox(width: 20),
    //                 TextButton(
    //                   onPressed: () async {
    //                     Get.back();
    //                     if (moodDevice != null) {
    //                       await moodDevice!.disconnect();
    //                       moodStatusController.allOff();
    //                     }
    //                   },
    //                   child: const Text(
    //                     '연결종료',
    //                     style: TextStyle(color: Colors.red),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  CupertinoAlertDialog createBLEDialog() => CupertinoAlertDialog(
    title: Text('기기와의 연결을 종료하시겠습니까?'),
    actions: [
      CupertinoDialogAction(child: Text('취소'), onPressed: () => Get.back()),
      CupertinoDialogAction(
        child: Text('연결종료', style: TextStyle(color: Colors.red)),
        onPressed: () async {
          if (moodDevice != null) {
            Get.back();
            await moodDevice!.disconnect();
            moodStatusController.allOff();
          }
        },
      ),
    ],
  );

  /// 휴대폰에 무드등이 페어링 되어있으면 연결후 true 반환 없으면 false
  Future<bool> checkSystemDevice() async {
    var systemDevices = await FlutterBluePlus.systemDevices([]);
    for (var systemDevice in systemDevices) {
      try {
        for (var sDeviceService in await systemDevice.discoverServices()) {
          if (sDeviceService.serviceUuid == Guid(BLE_MOOD_SERVICE_UUID)) {
            await systemDevice.connect();
            moodDevice = systemDevice;
            moodStatusController.connected.value = systemDevice.isConnected;
            debugPrint('연결됨');
            for (BluetoothService service
                in await systemDevice.discoverServices()) {
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid == Guid(BLE_MOOD_NOTIFICATION_UUID)) {
                  moodBleData.moodNotifiChr = characteristic;
                }
                if (characteristic.uuid == Guid(BLE_MOOD_READ_UUID)) {
                  moodBleData.moodReadChr = characteristic;
                }
                if (characteristic.uuid == Guid(BLE_MOOD_SERVICE_UUID)) {
                  moodBleData.moodServiceChr = characteristic;
                }
                if (characteristic.uuid == Guid(BLE_MOOD_WRITE_UUID)) {
                  moodBleData.moodWriteChr = characteristic;
                }
              }
            }
            moodBleData.readMoodNotifySetting();

            Fluttertoast.showToast(
              msg: "기기와 연결 되었습니다.",
              backgroundColor: const Color.fromARGB(230, 90, 90, 90),
            );
            return true;
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return false;
  }

  void initConnectMood() async {
    moodBleData.writeMood(FUNC_CODE_GET_FRONT_LIGHT, []);
    moodBleData.writeMood(FUNC_CODE_GET_BACK_LIGHT, []);
    moodBleData.setMoodRtc();
  }
}
