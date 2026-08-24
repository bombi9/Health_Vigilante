// GENERATED-LIKE CODE — hand-written Hive TypeAdapter for [WorkoutSession].

part of 'workout_session.dart';


class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 1;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      runDurationSeconds: fields[2] as int,
      walkDurationSeconds: fields[3] as int,
      reps: fields[4] as int,
      totalDurationSeconds: fields[5] as int,
      avgHeartRate: fields[6] as int?,
      paceMinPerKm: fields[7] as String?,
      elevationMeters: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.runDurationSeconds)
      ..writeByte(3)
      ..write(obj.walkDurationSeconds)
      ..writeByte(4)
      ..write(obj.reps)
      ..writeByte(5)
      ..write(obj.totalDurationSeconds)
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
      other is WorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
