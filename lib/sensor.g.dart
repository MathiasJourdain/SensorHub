// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sensor _$SensorFromJson(Map<String, dynamic> json) => _Sensor(
  id: json['id'] as String,
  name: json['name'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  battery: (json['battery'] as num).toInt(),
  status: json['status'] as String,
);

Map<String, dynamic> _$SensorToJson(_Sensor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'temperature': instance.temperature,
  'humidity': instance.humidity,
  'battery': instance.battery,
  'status': instance.status,
};
