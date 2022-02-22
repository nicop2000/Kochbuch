import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/backanweisung.dart';
import 'package:kochbuch/data/ingredient.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/mengen_einheit.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/detail_view.dart';

class CookbookList extends StatelessWidget {
  const CookbookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          MaterialButton(child: const Text("Add"), onPressed: newRec),
          StreamBuilder(
            stream: RecipeService.instance.recipeStream,
            builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView(
                    children: snapshot.data!
                        .map(
                          (e) => GestureDetector(
                            child: Text(e.title),
                            onTap: () {
                              log("TAPPED");
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => DetailView(recipe: e),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                );
              } else {
                return const Text("Nichts vorhanden");
              }
            },
          ),
        ],
      ),
    );
  }

  void newRec() {
    List<Instruction> inst = [
      Instruction(instruction: "Ma Ma Ma"),
      Instruction(instruction: "Me Me Me"),
      Instruction(instruction: "Mi Mi Mi")
    ];
    List<Ingredient> ingr = [
      Ingredient(menge: 20, einheit: MengenEinheit.g, zutat: "Zucker"),
      Ingredient(menge: 20, einheit: MengenEinheit.TL, zutat: "Mehl"),
    ];
    Recipe recipe = Recipe(
        title: "Testrezept",
        abteilung: Abteilung.dessert,
        fav: false,
        id: 1,
        link: "Das ist der Link",
        instructions: inst,
        ingredients: ingr,
        description: "Das ist eine Beschreibung",
        backanweisung: Backanweisung(
            backzeit: 20,
            temperatureinheit: Temperatureinheit.C,
            temperatur: 200));
    RuntimeState rts = RuntimeState();
    rts.addRecipe(recipe);
  }
}
