//import 'package:flutter/material.dart';
import 'package:get/get.dart';

AlarmController moodImageController = Get.put(AlarmController());

class AlarmController extends GetxController {
  RxInt selectedSoundIndex = 0.obs; //temporary
  RxInt selectedTimeIndex = 0.obs;

  final List<String> alarmTimeText = [
    '1분 동안',
    '3분 동안',
    '5분 동안',
    '10분 동안',
    '20분 동안',
    '30분 동안',
  ];

  final List<String> alarmSounds = [
    'Romantic Melodic',
    'Claudio the worm',
    'Morning folk song',
    'Sand castle',
    'Ocean, sea, beace ambience with seaguls',
    'Emotional piano',
    'Chirping birds',
    '소리 없음',
  ];

  final List<String> alarmSoundFiles = [
    'assets/alarmSound/Romantic_Melodic.wav',
    'assets/alarmSound/Claudio_the_worm.mp3',
    'assets/alarmSound/Morning_folk_song.mp3',
    'assets/alarmSound/Sand_castle.mp3',
    'assets/alarmSound/Ocean,_sea,_beace_ambience_with_seaguls.mp3',
    'assets/alarmSound/Emotional_piano.mp3',
    'assets/alarmSound/Chirping_birds.mp3',
    '',
  ];

  final List<int> alarmTimeNum = [1, 3, 5, 10, 20, 30];
}
