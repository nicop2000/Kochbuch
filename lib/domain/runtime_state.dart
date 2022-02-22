import 'package:flutter/cupertino.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_service.dart';

class RuntimeState extends ChangeNotifier {

  final List<Recipe> _recipes = [];


  addRecipe(Recipe recipe) {
    RecipeService.instance.addRecipe(recipe);
  }

  onAppRunning() {
    RecipeService.instance.recipeStream.listen((recipeList) {
      _recipes.clear();
      _recipes.addAll(recipeList);
      notifyListeners();
    });
  }

  removeRecipe(Recipe recipe) {
    RecipeService.instance.removeRecipe(recipe);
  }

  resetCookBook() async {
    _recipes.clear();
    await RecipeService.instance.resetCookbook();
  }

  List<Recipe> getRecipes() => _recipes;

}