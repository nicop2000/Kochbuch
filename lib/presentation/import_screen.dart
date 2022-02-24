import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kochbuch/common.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/domain/file_handler.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rezept_import_page_title, style: Theme.of(context).textTheme.headline1,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
              child: Text(AppLocalizations.of(context)!.rezept_import_einzeln_button_text, style: Theme.of(context).textTheme.button),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowMultiple: false,
                  allowedExtensions: ['json'],
                );

                if (result != null) {
                  try {
                  File file = File(result.files.single.path!);
                  Recipe recipe = FileHandler().acceptFileForSingle(file: file);
                  context.read<RuntimeState>().addRecipe(recipe);
                  successDialog(context);
                  } catch (e){
                    errorDialog(context);
                  }
                }
              },
            ),
            CupertinoButton(
                child: Text(AppLocalizations.of(context)!.rezept_import_collection_button_text, style: Theme.of(context).textTheme.button),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowedExtensions: ['json'],
                  );

                  if (result != null) {
                    try {
                    File file = File(result.files.single.path!);
                    List<Recipe> collection =
                        FileHandler().acceptFileForCollection(file: file);
                    context.read<RuntimeState>().addMultipleRecipes(collection);
                    successDialog(context);
                    } catch (e){
                      errorDialog(context);
                    }

                  }
                }),
          ],
        ),
      ),
    );
  }

  errorDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                AppLocalizations.of(context)!.rezept_import_error_dialog_title, style: Theme.of(context).textTheme.headline2),
            content: Text(
                AppLocalizations.of(context)!.rezept_import_error_dialog_text, style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.ok_button_text, style: Theme.of(context).textTheme.button),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  successDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                AppLocalizations.of(context)!.rezept_import_success_dialog_title, style: Theme.of(context).textTheme.headline2),
            content: Text(
                AppLocalizations.of(context)!.rezept_import_success_dialog_text, style: Theme.of(context).textTheme.bodyText1),
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
