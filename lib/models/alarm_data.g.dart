// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmDataAdapter extends TypeAdapter<AlarmData> {
  @override
  final int typeId = 0;

  @override
  AlarmData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmData(
      id: fields[0] as int,
      index: fields[1] as int,
      time: fields[2] as DateTime,
      repeatDay: (fields[3] as List).cast<bool>(),
      on: fields[4] as bool,
      ledBrightness: fields[5] as int,
      ledBrightnessDration: fields[6] as int,
      insertedDate: fields[7] as int,
      alarmSoundUri: fields[8] as String,
      alarmSoundVolume: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.repeatDay)
      ..writeByte(4)
      ..write(obj.on)
      ..writeByte(5)
      ..write(obj.ledBrightness)
      ..writeByte(6)
      ..write(obj.ledBrightnessDration)
      ..writeByte(7)
      ..write(obj.insertedDate)
      ..writeByte(8)
      ..write(obj.alarmSoundUri)
      ..writeByte(9)
      ..write(obj.alarmSoundVolume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
