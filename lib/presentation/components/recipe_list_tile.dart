import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/detail_view.dart';
import 'package:provider/provider.dart';


class RecipeListTile extends StatelessWidget {
  const RecipeListTile({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(
          horizontal: 10.0, vertical: 7.5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 2.0),
        leading: IconButton(
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            context.read<RuntimeState>().changeFavorite(recipe);
          },
          icon: Icon(
            recipe.fav ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
          ),
        ),
        title: Text(
          recipe.title,
          style: Theme.of(context).textTheme.headline3,
        ),
        trailing: recipe.image?.asImage(height: 50),
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => DetailView(recipe: recipe),
          ),
        ),
        onLongPress: () {
          context.read<RuntimeState>().changeFavorite(recipe);
        },
      ),
    );
  }
}