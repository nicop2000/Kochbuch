import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kochbuch/base/Ext.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/add_edit_recipe.dart';
import 'package:kochbuch/presentation/components/custom_divider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kochbuch/common.dart';

class DetailView extends StatelessWidget {
  DetailView({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;
  final controller = PageController(keepPage: true);
  final CrossAxisAlignment mainAlignment = CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    log(recipe.instructions.toString());
    log(recipe.ingredients.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title, style: Theme.of(context).textTheme.headline1,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.bearbeiten_button_tooltip,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => AddEditRecipe(
                    recipe: recipe,
                  ),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.pencil),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.loeschen_button_tooltip,
            onPressed: () async {
              bool delete = await confirmationOnDelete(context, recipe.title);
              if (delete) {
                context.read<RuntimeState>().removeRecipe(recipe);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(CupertinoIcons.delete),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, //TODO mit richtigem Rezept ausprobieren
                  crossAxisAlignment: mainAlignment,
                  children: [
                    if (recipe.image != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: recipe.image!.asImage(height: 150),
                          ),
                          CustomDivider()
                        ],
                      ),
                    if (recipe.description != null)
                      Column(
                        crossAxisAlignment: mainAlignment,
                        children: [
                          Text(AppLocalizations.of(context)!
                              .rezept_beschreibung_headline, style: Theme.of(context).textTheme.headline4),
                          Text(recipe.description!, style: Theme.of(context).textTheme.bodyText1,),

                          CustomDivider()
                        ],
                      ),
                    Text(
                      AppLocalizations.of(context)!.zutaten_page_title, style: Theme.of(context).textTheme.headline4,
                    ),
                    Column(
                      crossAxisAlignment: mainAlignment,
                      children: recipe.ingredients
                              ?.map((e) => Text(
                                  "${e.menge} ${e.einheit.name} ${e.zutat}", style: Theme.of(context).textTheme.bodyText1,))
                              .toList() ??
                          [
                            Text(AppLocalizations.of(context)!
                                .keine_zutaten_info_text, style: Theme.of(context).textTheme.bodyText1,)
                          ],
                    ),
                    CustomDivider(),
                    Text(AppLocalizations.of(context)!
                        .zubereitungsschritte_page_title, style: Theme.of(context).textTheme.headline4),
                    if (recipe.abteilung.isBackable())
                      Text(
                          "${recipe.backanweisung!.backzeit} ${AppLocalizations.of(context)!.rezept_backzeit_minuten_bei_text} ${recipe.backanweisung!.temperatureinheit.showName} ${AppLocalizations.of(context)!.rezept_backzeit_verb}", style: Theme.of(context).textTheme.bodyText1,),
                    if (recipe.instructions != null)
                      Container(
                        constraints: const BoxConstraints.expand(height: 300),
                        child: PageView.builder(
                          controller: controller,
                          itemCount: recipe.instructions?.length,
                          itemBuilder: (_, index) {
                            Instruction instruction = recipe.instructions![
                                index % recipe.instructions!.length];
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    child: Text(
                                      instruction.instruction,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  if (instruction.instructionImage != null)
                                    instruction.instructionImage!.asImage(height: 150)
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Text(AppLocalizations.of(context)!
                          .keine_zubereitungsschritte_info_text, style: Theme.of(context).textTheme.bodyText1,),
                    if (recipe.instructions != null)
                      Column(
                        children: [
                          SmoothPageIndicator(
                            controller: controller,
                            onDotClicked: (init) => controller.animateToPage(
                                init,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInQuad),
                            count: recipe.instructions!.length,
                            effect: JumpingDotEffect(
                              dotColor: Theme.of(context).colorScheme.secondary,
                              activeDotColor: Theme.of(context).colorScheme.primary,
                              verticalOffset: 20,
                              dotHeight: 8,
                              dotWidth: 8,
                              jumpScale: .7,
                            ),
                          ),
                          CustomDivider()
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (recipe.link != null)
                          CupertinoButton(
                              child: Text(AppLocalizations.of(context)!
                                  .rezept_im_browser_oeffnen_button_text, style: Theme.of(context).textTheme.button),
                              onPressed: () async {
                                String url = recipe.link!;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .fehler_text, style: Theme.of(context).textTheme.headline2,),
                                          content: Text(AppLocalizations.of(
                                                  context,)!
                                              .rezept_im_browser_error_dialog_text, style: Theme.of(context).textTheme.bodyText1,),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .ok_button_text, style: Theme.of(context).textTheme.button),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            )
                                          ],
                                        );
                                      });
                                }
                              }),
                        CupertinoButton(
                            child: Text(AppLocalizations.of(context)!
                                .exportieren_button_text, style: Theme.of(context).textTheme.button),
                            onPressed: () async {
                              await shareFile();
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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
                    AppLocalizations.of(context)!.rezept_loeschen_dialog_ja, style: Theme.of(context).textTheme.button)),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                  AppLocalizations.of(context)!.rezept_loeschen_dialog_nein, style: Theme.of(context).textTheme.button),
            ),
          ],
        );
      },
    );
  }

  Future<void> shareFile() async {
    Directory temporaryDirectory = await getTemporaryDirectory();

    String path =
        '${temporaryDirectory.path}/recipe-${recipe.title}-ID_${recipe.id}.json';
    File file = await File(path).create();
    file.writeAsStringSync(jsonEncode(recipe.toJson()));

    await FlutterShare.shareFile(
        fileType: 'application/json', title: recipe.title, filePath: file.path);
  }
}
