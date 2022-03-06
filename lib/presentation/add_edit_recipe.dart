import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kochbuch/base/Ext.dart';
import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/backanweisung.dart';
import 'package:kochbuch/data/ingredient.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/data/recipe_image.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/add_edit_ingredient.dart';
import 'package:kochbuch/presentation/add_edit_instruction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:kochbuch/common.dart';

class AddEditRecipe extends StatefulWidget {
  const AddEditRecipe({Key? key, this.recipe}) : super(key: key);
  final Recipe? recipe;

  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  List<Instruction> instructions = [];
  List<Ingredient> ingredients = [];
  TextEditingController titleTextController = TextEditingController();
  TextEditingController linkTextController = TextEditingController();
  TextEditingController timeTextController = TextEditingController();
  TextEditingController temperatureTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  File? image;

  final picker = ImagePicker();

  double size = 512;

  Abteilung _abteilung = Abteilung.fruehstueck;
  Temperatureinheit _temperatureinheit = Temperatureinheit.C;

  bool first = true;
  String title = "";
  String buttonText = "";

  @override
  Widget build(BuildContext context) {
    if (first && widget.recipe != null) {
      prepareForEditing();
    } else if (widget.recipe == null) {
      title = AppLocalizations.of(context)!.rezept_hinzufuegen_page_title;
      buttonText = AppLocalizations.of(context)!.rezept_hinzufuegen_button_text;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headline1,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoTextField(
                  controller: titleTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  placeholder:
                      AppLocalizations.of(context)!.rezept_titel_placeholder,
                ),
                CupertinoTextField(
                  controller: descriptionTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 3,
                  placeholder: AppLocalizations.of(context)!
                      .rezept_beschreibung_placeholder,
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CupertinoPicker(
                        selectionOverlay:
                            CupertinoPickerDefaultSelectionOverlay(
                          background:
                              Theme.of(context).colorScheme.primaryVariant,
                        ),
                        itemExtent: 25,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _abteilung = Abteilung.values.elementAt(value);
                          });
                        },
                        children: Abteilung.values
                            .map(
                              (e) => Text(
                                e.getInternational(context),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                            .toList()),
                  ),
                ),
                instructionsSection(),
                CupertinoButton(
                  child: Text(
                    AppLocalizations.of(context)!
                        .neuer_zubereitungsschritt_button_text, style: Theme.of(context).textTheme.button
                  ),
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => AddEditInstruction(
                        onPressed: (Instruction instruction) {
                          setState(() {
                            instructions.add(instruction);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ingredientsSection(),
                CupertinoButton(
                  child: Text(
                    AppLocalizations.of(context)!.neue_zutat_button_text, style: Theme.of(context).textTheme.button
                  ),
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => AddEditIngredient(
                        onPressed: (Ingredient ingredient) {
                          setState(() {
                            ingredients.add(ingredient);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                bakingTime(),
                CupertinoButton(
                    child: Text(
                      AppLocalizations.of(context)!
                          .bild_hinzufuegen_button_text, style: Theme.of(context).textTheme.button
                    ),
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return CupertinoAlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .bildquelle_auswaehlen_title, style: Theme.of(context).textTheme.headline2),
                              content: Column(
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .bildquelle_auswaehlen_text, style: Theme.of(context).textTheme.bodyText1),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .bildquelle_galerie_button_text, style: Theme.of(context).textTheme.button
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final newImg = await _imgFromGallery();
                                    if (newImg != null) {
                                      setState(() {
                                        image = File(newImg.path);
                                      });
                                    }
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .bildquelle_kamera_button_text, style: Theme.of(context).textTheme.button
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final newImg = await _imgFromCamera();
                                    if (newImg != null) {
                                      setState(() {
                                        image = File(newImg.path);
                                      });
                                    }
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .abbrechen_button_text, style: Theme.of(context).textTheme.button
                                  ),
                                  onPressed: () async =>
                                      Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          });
                    }),
                if (image != null)
                  Column(
                    children: [
                      Image.file(
                        image!,
                        height: 200,
                      ),
                      CupertinoButton(
                          child: Text(
                            AppLocalizations.of(context)!.rezept_bild_loeschen, style: Theme.of(context).textTheme.button
                          ),
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          })
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CupertinoTextField(
                    controller: linkTextController,
                    style: Theme.of(context).textTheme.bodyText1,
                    keyboardType: TextInputType.text,
                    placeholder:
                        AppLocalizations.of(context)!.rezept_link_placeholder,
                  ),
                ),
                CupertinoButton(
                    child: Text(
                      buttonText, style: Theme.of(context).textTheme.button
                    ),
                    onPressed: () {
                      Recipe recipe = Recipe(
                          id: 1,
                          title: titleTextController.text,
                          description: descriptionTextController.text.isEmpty
                              ? null
                              : descriptionTextController.text,
                          abteilung: _abteilung,
                          backanweisung: _abteilung.isBackable()
                              ? Backanweisung(
                                  backzeit:
                                      int.tryParse(timeTextController.text) ??
                                          -1,
                                  temperatureinheit: _temperatureinheit,
                                  temperatur: int.tryParse(
                                          temperatureTextController.text) ??
                                      -1)
                              : null,
                          fav: false,
                          ingredients: ingredients.isEmpty ? null : ingredients,
                          instructions:
                              instructions.isEmpty ? null : instructions,
                          link: linkTextController.text.isEmpty
                              ? null
                              : linkTextController.text,
                          image: image != null
                              ? RecipeImage(
                                  base64String:
                                      base64Encode(image!.readAsBytesSync()))
                              : null);
                      context.read<RuntimeState>().addRecipe(recipe);
                      if (widget.recipe != null) {
                        context
                            .read<RuntimeState>()
                            .removeRecipe(widget.recipe!);
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void prepareForEditing() {
    first = false;
    titleTextController.text = widget.recipe!.title;
    descriptionTextController.text = widget.recipe!.description ?? "";
    linkTextController.text = widget.recipe!.link ?? "";
    timeTextController.text =
        widget.recipe!.backanweisung?.backzeit.toString() ?? "";
    temperatureTextController.text =
        widget.recipe!.backanweisung?.temperatur.toString() ?? "";
    _temperatureinheit =
        widget.recipe!.backanweisung?.temperatureinheit ?? Temperatureinheit.C;
    _abteilung = widget.recipe!.abteilung;
    instructions = List.from(widget.recipe!.instructions ?? []);
    ingredients = List.from(widget.recipe!.ingredients ?? []);
    if (widget.recipe!.image != null) {
      getTemporaryDirectory().then((value) async {
        Uint8List imageInUnit8List = base64Decode(
            widget.recipe!.image!.base64String); // store unit8List image here ;
        File file = await File('${value.path}/image.png').create();
        file.writeAsBytesSync(imageInUnit8List);
        setState(() {
          image = file;
        });
      });
    }
    title = AppLocalizations.of(context)!.rezept_bearbeiten_page_title;
    buttonText =
        AppLocalizations.of(context)!.rezept_bearbeiten_button_text;
  }

  //TODO: Leere Felder nicht erlauben

  Widget instructionsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: instructions.isNotEmpty
          ? instructions
              .map((e) => Row(
                    children: [
                      Text(
                          "${e.instruction.substring(0, e.instruction.length > 20 ? 20 : e.instruction.length)} ${e.instruction.length > 20 ? "..." : ""}",
                          style: Theme.of(context).textTheme.bodyText1,),
                      if (e.instructionImage != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Icon(CupertinoIcons.paperclip, color: Theme.of(context).colorScheme.onPrimary,),
                        ),
                      const Spacer(),
                      IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                        tooltip: AppLocalizations.of(context)!
                            .bearbeiten_button_tooltip,
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => AddEditInstruction(
                                instruction: e,
                                onPressed: (Instruction editedInstruction) {
                                  setState(() {
                                    instructions[instructions.indexWhere(
                                            (element) => element == e)] =
                                        editedInstruction;
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(CupertinoIcons.pencil),
                      ),
                      IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                          tooltip: AppLocalizations.of(context)!
                              .loeschen_button_tooltip,
                          onPressed: () {
                            setState(() {
                              instructions
                                  .removeWhere((element) => element == e);
                            });
                          },
                          icon: const Icon(CupertinoIcons.delete))
                    ],
                  ))
              .toList()
          : [],
    );
  }

  Widget ingredientsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: ingredients.isNotEmpty
          ? ingredients
              .map((e) => Row(
                    children: [
                      Text("${e.menge ?? ""} ",style: Theme.of(context).textTheme.bodyText1,),
                      Text(e.einheit.showName,style: Theme.of(context).textTheme.bodyText1,),
                      Text(e.zutat,style: Theme.of(context).textTheme.bodyText1,),
                      const Spacer(),
                      IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                        tooltip: AppLocalizations.of(context)!
                            .bearbeiten_button_tooltip,
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => AddEditIngredient(
                                ingredient: e,
                                onPressed: (Ingredient editedIngredient) {
                                  setState(() {
                                    ingredients[ingredients.indexWhere(
                                            (element) => element == e)] =
                                        editedIngredient;
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(CupertinoIcons.pencil),
                      ),
                      IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                          tooltip: AppLocalizations.of(context)!
                              .loeschen_button_tooltip,
                          onPressed: () {
                            setState(() {
                              ingredients
                                  .removeWhere((element) => element == e);
                            });
                          },
                          icon: const Icon(CupertinoIcons.delete))
                    ],
                  ))
              .toList()
          : [],
    );
  }

  Widget bakingTime() {
    return Visibility(
      visible: _abteilung.isBackable(),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Row(
        children: [
          Flexible(
            child: CupertinoTextField(
                controller: timeTextController,
                style: Theme.of(context).textTheme.bodyText1,
                placeholder: AppLocalizations.of(context)!
                    .rezept_backzeit_zeit_placeholder,
                keyboardType: TextInputType.number),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
                AppLocalizations.of(context)!.rezept_backzeit_minuten_bei_text,
              style: Theme.of(context).textTheme.bodyText1,),
          ),
          Flexible(
            child: CupertinoTextField(
              controller: temperatureTextController,
              style: Theme.of(context).textTheme.bodyText1,
              placeholder: AppLocalizations.of(context)!
                  .rezept_backzeit_temperatur_bei_placeholder,
              keyboardType: TextInputType.number,
            ),
          ),
          Flexible(
            child: CupertinoPicker(
              itemExtent: 25,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: Theme.of(context).colorScheme.primaryVariant,
              ),
              onSelectedItemChanged: (value) {
                _temperatureinheit = Temperatureinheit.values.elementAt(value);
              },
              children: Temperatureinheit.values
                  .map((e) => Text(e.showName, style: Theme.of(context).textTheme.bodyText1,))
                  .toList(),
            ),
          ),
          Text(AppLocalizations.of(context)!.rezept_backzeit_verb, style: Theme.of(context).textTheme.bodyText2,),
        ],
      ),
    );
  }

  Future<XFile?> _imgFromCamera() async {
    final imageFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: size, maxWidth: size);
    return imageFile;
  }

  Future<XFile?> _imgFromGallery() async {
    final imageFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: size, maxWidth: size);
    return imageFile;
  }
}
