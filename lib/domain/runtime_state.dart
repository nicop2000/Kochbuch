import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_service.dart';

class RuntimeState extends ChangeNotifier {

  final List<Recipe> _recipes = [];


  addRecipe(Recipe recipe) async {
    _recipes.add(await RecipeService.instance.addRecipe(recipe));
    notifyListeners();
  }

  addMultipleRecipes(List<Recipe> recipeList) async {
    for(Recipe recipe in recipeList) {
      _recipes.add(await RecipeService.instance.addRecipe(recipe));
    }
    notifyListeners();
  }

  void init() {
    _recipes.clear();
    _recipes.addAll(RecipeService.instance.recepies);
  }

  removeRecipe(Recipe recipe) async {
    await RecipeService.instance.removeRecipe(recipe);
    _recipes.removeWhere((element) => element == recipe);
    notifyListeners();
    // RecipeService.instance.removeRecipe(recipe);
  }

  changeFavorite(Recipe recipe) async {
    int index = _recipes.indexWhere((element) => element == recipe);
    _recipes[index].fav = !_recipes[index].fav;
    RecipeService.instance.updateFavoritePreferenceRecipe(recipe);
    notifyListeners();
  }
  resetCookBook() async {
    _recipes.clear();
    await RecipeService.instance.resetCookbook();
    notifyListeners();
  }

  List<Recipe> getRecipes() => _recipes;

  String exportRecipeCollectionToJson() => jsonEncode(_recipes);

}