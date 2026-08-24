// GENERATED-LIKE CODE — hand-written Hive TypeAdapter for [DailyHistory].

part of 'daily_history.dart';


class DailyHistoryAdapter extends TypeAdapter<DailyHistory> {
  @override
  final int typeId = 2;

  @override
  DailyHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyHistory(
      date: fields[0] as DateTime,
      dayScore: fields[1] as int,
      totalRunningMinutes: fields[2] as int,
      currentStreak: fields[3] as int,
      isPersonalBest: fields[4] as bool? ?? false,
      sessionIds: (fields[5] as List?)?.cast<String>() ?? [],
      avgHeartRate: fields[6] as int?,
      paceMinPerKm: fields[7] as String?,
      elevationMeters: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyHistory obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.dayScore)
      ..writeByte(2)
      ..write(obj.totalRunningMinutes)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.isPersonalBest)
      ..writeByte(5)
      ..write(obj.sessionIds)
      ..writeByte(6)
      ..write(obj.avgHeartRate)
      ..writeByte(7)
      ..write(obj.paceMinPerKm)
      ..writeByte(8)
      ..write(obj.elevationMeters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
