import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kochbuch/domain/file_handler.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:kochbuch/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.rezept_einstellungen_page_title,
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          CupertinoButton(
            child: Text(
                AppLocalizations.of(context)!
                    .rezept_export_collection_button_text,
                style: Theme.of(context).textTheme.button),
            onPressed: () {
              FileHandler().shareCookbookAsJSON(cookbook: context.read<RuntimeState>().exportRecipeCollectionToJson(), cookbookLength: context.read<RuntimeState>().getRecipes().length);
            },
          ),
          CupertinoButton(
            child: Text(AppLocalizations.of(context)!.kochbuch_zuruecksetzen_button_text,
                style: Theme.of(context).textTheme.button),
            onPressed: () async {
              resetCookbook(context);
            },
          )
        ],
      ),
    );
  }



  successDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                AppLocalizations.of(context)!.rezept_success_dialog_title, style: Theme.of(context).textTheme.headline2),
            content: Text(AppLocalizations.of(context)!.kochbuch_zuruecksetzen_success_dialog_text
                , style: Theme.of(context).textTheme.bodyText1),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.ok_button_text, style: Theme.of(context).textTheme.button),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  confirmationDialog(BuildContext context) async {
    return await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                AppLocalizations.of(context)!.kochbuch_zuruecksetzen_confirmation_dialog_title, style: Theme.of(context).textTheme.headline2), //TODO
            content: Text(AppLocalizations.of(context)!.kochbuch_zuruecksetzen_confirmation_dialog_text
                , style: Theme.of(context).textTheme.bodyText1),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.rezept_loeschen_dialog_ja, style: Theme.of(context).textTheme.button),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.rezept_loeschen_dialog_nein, style: Theme.of(context).textTheme.button),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        });
  }

  void resetCookbook(BuildContext context) async {
    if(await confirmationDialog(context)) {
    await context.read<RuntimeState>().resetCookBook();
    successDialog(context);
    }
  }
}
