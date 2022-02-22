// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backanweisung.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Backanweisung _$BackanweisungFromJson(Map<String, dynamic> json) =>
    Backanweisung(
      backzeit: json['backzeit'] as int,
      temperatureinheit:
          $enumDecode(_$TemperatureinheitEnumMap, json['temperatureinheit']),
      temperatur: json['temperatur'] as int,
    );

Map<String, dynamic> _$BackanweisungToJson(Backanweisung instance) =>
    <String, dynamic>{
      'backzeit': instance.backzeit,
      'temperatur': instance.temperatur,
      'temperatureinheit':
          _$TemperatureinheitEnumMap[instance.temperatureinheit],
    };

const _$TemperatureinheitEnumMap = {
  Temperatureinheit.C: 'C',
  Temperatureinheit.F: 'F',
  Temperatureinheit.K: 'K',
  Temperatureinheit.Watt: 'Watt',
};
