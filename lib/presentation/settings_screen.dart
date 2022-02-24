import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
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
              shareCookbook(context);
            },
          ),
          CupertinoButton(
            child: Text("Kochbuch zurücksetzen", //TODO
                style: Theme.of(context).textTheme.button),
            onPressed: () async {
              await context.read<RuntimeState>().resetCookBook();
              successDialog(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> shareCookbook(BuildContext context) async {
    Directory temporaryDirectory = await getTemporaryDirectory();

    String path = '${temporaryDirectory.path}/recipe-collection-'
        'size-${context.read<RuntimeState>().getRecipes().length}-'
        'date-${DateTime.now().toLocal()}.json';
    File file = await File(path).create();
    file.writeAsStringSync(
        context.read<RuntimeState>().exportRecipeCollectionToJson());

    await FlutterShare.shareFile(
        fileType: 'application/json',
        title: path.split('/').last,
        filePath: file.path);
  }

  successDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                "Erfolg", style: Theme.of(context).textTheme.headline2), //TODO
            content: Text(
                "Das Kochbuch wurde erfolgreich zurückgesetzt. Alle Rezepte und Einstellungen wurden entfernt", style: Theme.of(context).textTheme.bodyText1), //TODO
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.ok_button_text, style: Theme.of(context).textTheme.button),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
