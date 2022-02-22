import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kochbuch/data/recipe.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(recipe.title),
        backgroundColor: CupertinoColors.systemRed,
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: recipe.instructions?.map((e) => Text(e.instruction)).toList() ?? [],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: recipe.ingredients?.map((e) => Text("${e.menge} ${e.einheit.name} ${e.zutat}")).toList() ?? [],
                ),

                // if(recipe.image != null)
                // Image.memory(base64Decode(recipe.image!.base64String), height: 200,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
