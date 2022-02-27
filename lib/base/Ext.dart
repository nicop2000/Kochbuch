import 'package:flutter/cupertino.dart';
import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/backanweisung.dart';
import 'package:kochbuch/common.dart';
import 'package:kochbuch/data/mengen_einheit.dart';
import 'package:kochbuch/data/recipe.dart';

extension TemperatureinheitNamen on Temperatureinheit {
  String get showName =>
      name.length > 1 ? name[0].toUpperCase() +
          name.substring(1)
              .toLowerCase() : "°$name";

}

extension MengeneinheitNamen on MengenEinheit {
  String get showName => this == MengenEinheit.NULL ? "" : name + " ";
}



extension AbteilungsNamen on Abteilung {
  String get showName =>
      name[0].toUpperCase() +
          name.substring(1)
              .toLowerCase()
              .replaceAll("ae", "ä")
              .replaceAll("oe", "ö")
              .replaceAll("ue", "ü");

  bool _isInList(List<Abteilung> list) {
    for (Abteilung element in list) {
      if (element.name == name) return true;
    }
    return false;
  }

  bool isBackable() {
    return _isInList([
      Abteilung.gebaeck,
      Abteilung.kekse,
      Abteilung.kuchen,
      Abteilung.torte,
      Abteilung.brot
    ]);
  }
}

extension AbteilungMap on Abteilung {
  String getInternational(BuildContext context) {
  Map<Abteilung, String> _map = {
    Abteilung.fruehstueck : AppLocalizations
        .of(context)!.fruehstueck,
    Abteilung.mittagessen : AppLocalizations
        .of(context)!.mittagessen,
    Abteilung.abendessen : AppLocalizations
        .of(context)!.abendessen,
    Abteilung.dessert : AppLocalizations
        .of(context)!.dessert,
    Abteilung.torte : AppLocalizations
        .of(context)!.torte,
    Abteilung.kuchen : AppLocalizations
        .of(context)!.kuchen,
    Abteilung.kekse : AppLocalizations
        .of(context)!.kekse,
    Abteilung.gebaeck : AppLocalizations
        .of(context)!.gebaeck,
    Abteilung.brot : AppLocalizations
        .of(context)!.brot,
    Abteilung.salate : AppLocalizations
        .of(context)!.salate,
    Abteilung.cocktail : AppLocalizations
        .of(context)!.cocktail,
    Abteilung.sonstiges : AppLocalizations
        .of(context)!.sonstiges,
    Abteilung.marinade : AppLocalizations.of(context)!.marinade
  };
    return _map[this]!;
  }
}

extension ListRecipeWhere on List<Recipe> {
  List<Recipe> whereTitle(String string) {
    List<Recipe> result = [];
    for (Recipe recipe in this) {
      if (recipe.title.toLowerCase().contains(string.toLowerCase())) {
        result.add(recipe);
      }
    }
    return result;
  }

  List<Recipe> filterFavorites(bool filter) {
    if(!filter) return this;
    List<Recipe> result = [];
    for (Recipe recipe in this) {
      if (recipe.fav) {
        result.add(recipe);
      }
    }
    return result;
  }
}
