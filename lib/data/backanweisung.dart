
import 'package:json_annotation/json_annotation.dart';

part 'backanweisung.g.dart';

@JsonSerializable()
class Backanweisung {

  int backzeit;
  int temperatur;
  Temperatureinheit temperatureinheit;

  Backanweisung({required this.backzeit, required this.temperatureinheit, required this.temperatur});

factory Backanweisung.fromJson(Map<String, dynamic> json) =>
_$BackanweisungFromJson(json);

Map<String, dynamic> toJson() => _$BackanweisungToJson(this);
}

enum Temperatureinheit {
  C,
  F,
  K,
  Watt
}

