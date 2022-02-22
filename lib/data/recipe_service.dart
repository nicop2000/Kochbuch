


import 'dart:async';
import 'dart:convert';

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

  final _controller = StreamController<List<Recipe>>();

  Stream<List<Recipe>> get recipeStream => _controller.stream;



  addRecipe(Recipe recipe) async {
    Recipe normedRecipe = _normRecipe(recipe);
    await prefs?.setString(_getRecipeKey(normedRecipe.id), jsonEncode(normedRecipe.toJson()));
    _setMax(normedRecipe.id);
    _recipes.add(normedRecipe);
    emitStream();
  }

  removeRecipe(Recipe recipe) async {
    await prefs?.remove(_getRecipeKey(recipe.id));
    _recipes.removeWhere((element) => element.id == recipe.id);
    emitStream();
  }

  String _getRecipeKey(int recipeID) => "$_recipePrefix + $recipeID";
  int _getMax() => prefs?.getInt(_preferencesMaxID) ?? 0;
  _setMax(int max) => prefs?.setInt(_preferencesMaxID, max);
  Recipe _normRecipe(Recipe recipe) => Recipe.copyWithNewId(recipe, _getMax() + 1);

  void emitStream() {
    _controller.sink.add(_recipes);
  }

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
    emitStream();
  }

  Recipe? _loadRecipe(String prefsID) {
    String? recipeJson = prefs?.getString(prefsID);
    if (recipeJson != null) return Recipe.fromJson(jsonDecode(recipeJson));
  }

  resetCookbook() async {
    await prefs?.clear();
    _controller.sink.add([]);
  }

}

