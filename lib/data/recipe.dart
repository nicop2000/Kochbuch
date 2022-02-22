import 'package:json_annotation/json_annotation.dart';
import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/backanweisung.dart';
import 'package:kochbuch/data/ingredient.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/recipe_image.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  int id = 0;
  String title;
  String? description;
  Abteilung abteilung = Abteilung.sonstiges;
  Backanweisung? backanweisung;
  List<Ingredient>? ingredients;
  List<Instruction>? instructions;
  String? link;
  RecipeImage? image;
  bool fav = false;

  Recipe({
    required this.title,
    this.description,
    required this.abteilung,
    this.backanweisung,
    required this.fav,
    required this.id,
    this.ingredients,
    this.instructions,
    this.link,
    this.image,
  });

  static Recipe copyWithNewId(Recipe recipe, int newID) {
    return Recipe(
        title: recipe.title,
        abteilung: recipe.abteilung,
        fav: recipe.fav,
        id: newID,
        backanweisung: recipe.backanweisung,
        description: recipe.description,
        image: recipe.image,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        link: recipe.link,);
  }

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

}
