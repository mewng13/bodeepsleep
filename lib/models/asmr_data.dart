import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Map<String, Map<String, List<AsmrData>>> asmrCtg1Datas = {};
Future<void> loadAsmrData() async {
  String databasePath = await getDatabasesPath();
  String dbPath = join(databasePath, 'asmr.db');

  debugPrint(dbPath);

  ByteData data = await rootBundle.load('assets/asmr/db/asmr.db');
  List<int> bytes = data.buffer.asUint8List(
    data.offsetInBytes,
    data.lengthInBytes,
  );
  await File(dbPath).writeAsBytes(bytes, flush: true);

  Database database = await openDatabase(dbPath);

  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT * FROM sound_therapy',
  );

  List<AsmrData> asmrDataList = [];
  for (Map<String, dynamic> row in result) {
    AsmrData asmrData = AsmrData(
      idx: row['idx'],
      code: row['code'],
      ctg1: row['ctg1'],
      ctg1Sub: row['ctg1_sub'],
      ctg2: row['ctg2'],
      cls: row['class'],
      title: row['title'],
      narration: row['narration'] == 1,
      repeat: row['repeat'] == 1,
      thumbnail: row['thumbnail'],
      backgroundImage: row['bgimage'],
      info: row['info'] ?? '',
      infoTitle: row['info_title'] ?? '',
      infoSubTitle: row['info_subtitle'] ?? '',
      sound: row['sound'],
    );
    asmrDataList.add(asmrData);
  }

  for (var asmrData in asmrDataList) {
    String ctg2 = asmrData.ctg2;
    String ctg1 = asmrData.ctg1;

    if (!asmrCtg1Datas.containsKey("전체")) {
      asmrCtg1Datas["전체"] = {};
    }

    if (!asmrCtg1Datas["전체"]!.containsKey(ctg1)) {
      asmrCtg1Datas["전체"]![ctg1] = [];
    }

    if (!asmrCtg1Datas.containsKey(ctg2)) {
      asmrCtg1Datas[ctg2] = {};
    }

    if (!asmrCtg1Datas[ctg2]!.containsKey(ctg1)) {
      asmrCtg1Datas[ctg2]![ctg1] = [];
    }

    asmrCtg1Datas[ctg2]![ctg1]!.add(asmrData);
    asmrCtg1Datas['전체']![ctg1]!.add(asmrData);
  }
}

class AsmrData {
  int idx;
  String code;
  String ctg1;
  String ctg1Sub;
  String ctg2;
  String cls;
  String title;
  bool narration;
  bool repeat;
  String thumbnail;
  String backgroundImage;
  String info;
  String infoTitle;
  String infoSubTitle;
  String sound;
  late Audio audio;
  AsmrData({
    required this.idx,
    required this.code,
    required this.ctg1,
    required this.ctg1Sub,
    required this.ctg2,
    required this.cls,
    required this.title,
    required this.narration,
    required this.repeat,
    required this.thumbnail,
    required this.backgroundImage,
    required this.info,
    required this.infoTitle,
    required this.infoSubTitle,
    required this.sound,
  }) {
    code = code.toLowerCase();
    try {
      sound = sound.replaceAll(' ', '_');
      audio = Audio(
        'assets/asmr/sound/$sound',
        metas: Metas(
          id: code,
          title: title,
          // artist: 'Florent Champigny',
          // album: 'RockAlbum',
          image: MetasImage.asset('assets/asmr/image/thumbnail/$code.jpg'),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
