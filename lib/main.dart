import 'package:flutter/cupertino.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/presentation/add_recipe.dart';
import 'package:kochbuch/presentation/cookbook_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  RecipeService.instance.prefs = preferences;
  RecipeService.instance.loadRecipes();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final List<Widget> _tabs = [ const AddRecipe(), const CookbookList(),];
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home:
      CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book), label: 'Rezepte'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.camera), label: 'Neues Rezept')
            ],
          ),
          tabBuilder: (BuildContext context, index) {
            return _tabs[index];
          }),
    );
  }
}
