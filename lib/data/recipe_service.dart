


import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:kochbuch/data/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  SharedPreferences? prefs;


  static final RecipeService instance = RecipeService._internal();
  final String _preferencesMaxID = "maxID";
  final String _recipePrefix = "cookbook.recipe-";

  final List<Recipe> _recipes = [];

  factory RecipeService() {
    return instance;
  }
  RecipeService._internal();

  List<Recipe> get recepies => _recipes;

  Future<Recipe> addRecipe(Recipe recipe) async {
    Recipe normedRecipe = normRecipe(recipe);
    await prefs?.setString(_getRecipeKey(normedRecipe.id), jsonEncode(normedRecipe.toJson()));
    _setMax(normedRecipe.id);
    _recipes.add(normedRecipe);
    return normedRecipe;
  }


  Future<void> removeRecipe(Recipe recipe) async {
    log("start");
    await prefs?.remove(_getRecipeKey(recipe.id));
    log("mid");
    _recipes.removeWhere((element) => element.id == recipe.id);
    log("DONE");
    return;
  }

  Future<void> updateFavoritePreferenceRecipe(Recipe recipe) async {
    await prefs?.setString(_getRecipeKey(recipe.id), jsonEncode(recipe.toJson()));
    return;
  }

  String _getRecipeKey(int recipeID) => "$_recipePrefix + $recipeID";
  int _getMax() => prefs?.getInt(_preferencesMaxID) ?? 0;
  _setMax(int max) => prefs?.setInt(_preferencesMaxID, max);
  Recipe normRecipe(Recipe recipe) => Recipe.copyWithNewId(recipe, _getMax() + 1);

   void loadRecipes() {
    int max = _getMax();
    List<Recipe> loaded = [];
    for (int i = 0; i <= max; i++) {
      Recipe? recipe = _loadRecipe(_getRecipeKey(i));
      if (recipe != null) {
        loaded.add(recipe);
      }
    }
    _recipes.clear();
    _recipes.addAll(loaded);
  }

  Recipe? _loadRecipe(String prefsID) {
    String? recipeJson = prefs?.getString(prefsID);
    if (recipeJson != null) return Recipe.fromJson(jsonDecode(recipeJson));
  }

  resetCookbook() async {
    await prefs?.clear();
    _recipes.clear();
  }

}

