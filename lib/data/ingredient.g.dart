// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      menge: json['menge'] as int,
      zutat: json['zutat'] as String,
      einheit: $enumDecode(_$MengenEinheitEnumMap, json['einheit']),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'menge': instance.menge,
      'zutat': instance.zutat,
      'einheit': _$MengenEinheitEnumMap[instance.einheit],
    };

const _$MengenEinheitEnumMap = {
  MengenEinheit.g: 'g',
  MengenEinheit.kg: 'kg',
  MengenEinheit.ml: 'ml',
  MengenEinheit.l: 'l',
  MengenEinheit.TL: 'TL',
  MengenEinheit.EL: 'EL',
  MengenEinheit.Msp: 'Msp',
  MengenEinheit.Prise: 'Prise',
};
