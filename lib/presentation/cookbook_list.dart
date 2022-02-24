import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kochbuch/base/Ext.dart';
import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/add_edit_recipe.dart';
import 'components/dismissible_background.dart';
import 'components/recipe_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:kochbuch/common.dart';

class CookbookList extends StatefulWidget {
  const CookbookList({Key? key}) : super(key: key);

  @override
  State<CookbookList> createState() => _CookbookListState();
}

class _CookbookListState extends State<CookbookList> {
  bool searchMode = false;
  bool filterFavorite = false;
  String searchValue = "";

  Widget getAppBar() {
    if (searchMode) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: CupertinoTextField(
                  placeholder: "Name eingeben", //TODO
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: (string) => setState(() {
                    searchValue = string;
                  }),
                  maxLines: 1,
                  clearButtonMode: OverlayVisibilityMode.always,
                  suffix: Icon(CupertinoIcons.search, color: Theme.of(context).colorScheme.onPrimary,),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(AppLocalizations.of(context)!.alle_rezepte, style: Theme.of(context).textTheme.headline1,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: getAppBar(),
        centerTitle: true,
        leading: IconButton(
          color: Theme.of(context).colorScheme.secondary,
          tooltip: "", //TODO,
          onPressed: () {
            setState(() {
              filterFavorite = !filterFavorite;
            });
          },
          icon: Icon(filterFavorite ? CupertinoIcons.heart_solid : CupertinoIcons.heart,),
        ),
        actions: [
          Visibility(
            visible: !searchMode,
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child:
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              tooltip: AppLocalizations.of(context)!.hinzufuegen_button_tooltip,
              onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const AddEditRecipe())),
              icon: const Icon(CupertinoIcons.add),
            ),),
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            tooltip: "", //TODO
            onPressed: () => setState(() {
              searchMode = !searchMode;
              searchValue = "";
            }),
            icon:
                Icon(searchMode ? CupertinoIcons.clear : CupertinoIcons.search),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<Recipe, Abteilung>(
              elements: context.watch<RuntimeState>().getRecipes().whereTitle(searchValue).filterFavorites(filterFavorite),
              groupBy: (element) => element.abteilung,
              groupComparator: (value1, value2) =>
                  value2.name.compareTo(value1.name),
              itemComparator: (item1, item2) =>
                  item1.title.compareTo(item2.title),
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              stickyHeaderBackgroundColor: Theme.of(context).colorScheme.background,
              groupSeparatorBuilder: (Abteilung value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.getInternational(context),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              itemBuilder: (c, element) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (DismissDirection direction) async {
                    return await confirmationOnDelete(context, element.title);
                  },
                  key: Key("${element.title}-${element.id}"),
                  onDismissed: (direction) {
                    context.read<RuntimeState>().removeRecipe(element);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: Text(AppLocalizations.of(context)!
                            .rezept_geloescht_info_text(element.title), style: Theme.of(context).textTheme.bodyText1,),
                      ),
                    );
                  },
                  // Show a red background as the item is swiped away.
                  background: const DismissibleBackground(),
                  child: RecipeListTile(recipe: element),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  confirmationOnDelete(BuildContext context, String title) async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title:
              Text(AppLocalizations.of(context)!.rezept_loeschen_dialog_title, style: Theme.of(context).textTheme.headline2),
          content: Text(
              AppLocalizations.of(context)!.rezept_loeschen_dialog_text(title), style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                    AppLocalizations.of(context)!.rezept_loeschen_dialog_ja, style: Theme.of(context).textTheme.button,),),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                  AppLocalizations.of(context)!.rezept_loeschen_dialog_nein, style: Theme.of(context).textTheme.button,),
            ),
          ],
        );
      },
    );
  }
}
