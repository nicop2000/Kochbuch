
import 'package:json_annotation/json_annotation.dart';
import 'package:kochbuch/data/mengen_einheit.dart';

part 'ingredient.g.dart';
@JsonSerializable()
class Ingredient {

  int? menge;
  String zutat;
  MengenEinheit einheit;

  Ingredient({required this.menge, required this. zutat, required this.einheit});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}