import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import 'package:kochbuch/presentation/add_ingredient.dart';
import 'package:kochbuch/presentation/add_instruction.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key? key}) : super(key: key);

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<Instruction> instructions = [];
  List<Ingredient> ingredients = [];
  TextEditingController titleTextController = TextEditingController();
  TextEditingController linkTextController = TextEditingController();
  TextEditingController timeTextController = TextEditingController();
  TextEditingController temperatureTextController = TextEditingController();

  File? image;

  final picker = ImagePicker();

  double size = 512;

  Abteilung _abteilung = Abteilung.fruehstueck;
  Temperatureinheit _temperatureinheit = Temperatureinheit.C;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Neues Rezept hinzufügen"),
        backgroundColor: CupertinoColors.systemRed,
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoTextField(
                  controller: titleTextController,
                  placeholder: "Titel des Rezepts eingeben",
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CupertinoPicker(
                        itemExtent: 25,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _abteilung = Abteilung.values.elementAt(value);
                          });
                        },
                        children: Abteilung.values
                            .map((e) => Text(e.showName))
                            .toList()),
                  ),
                ),

                instructionsSection(),
                CupertinoButton(
                  child: const Text("Neuen Schritt hinzufügen"),
                  onPressed: () =>
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) =>
                              AddInstruction(
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
                  child: const Text("Neue Zutat hinzufügen"),
                  onPressed: () =>
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) =>
                              AddIngredient(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CupertinoTextField(
                    controller: linkTextController,
                    keyboardType: TextInputType.text,
                    placeholder: "Link zum Rezept (optional)",
                  ),
                ),
                CupertinoButton(
                    child: const Text("Bild hinzufügen"),
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return CupertinoAlertDialog(
                              title: const Text("Bild auswählen"),
                              content: Column(
                                children: const [
                                  Text(
                                      "Aus welcher Quelle soll das Bild importiert werden?"),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child:
                                  const Text("Bild aus Galerie auswählen"),
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
                                  child:
                                  const Text("Bild mit Kamera aufnehmen"),
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
                                  child:
                                  const Text("Abbrechen"),
                                  onPressed: () async =>
                                      Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          });
                    }),
                if (image != null)
                  Image.file(
                    image!,
                    height: 200,
                  ),
                CupertinoButton(child: Text("PRINT"), onPressed: () {
                  RecipeImage rI = RecipeImage(
                      base64String:
                      base64Encode(image!.readAsBytesSync()));
                  log(rI.base64String.length.toString());
                }),
                CupertinoButton(
                    child: const Text("Rezept hinzufügen"),
                    onPressed: () {

                      Recipe recipe = Recipe(
                          id: 1,
                          title: titleTextController.text,
                          abteilung: _abteilung,
                          backanweisung: _abteilung.isBackable() ? Backanweisung(
                              backzeit: int.tryParse(timeTextController.text) ?? -1,
                              temperatureinheit: _temperatureinheit,
                              temperatur: int.tryParse(temperatureTextController.text) ?? -1) : null,
                          fav: false,
                          ingredients: ingredients,
                          instructions: instructions,
                          link: linkTextController.text,
                          image: image != null
                              ? RecipeImage(
                              base64String:
                              base64Encode(image!.readAsBytesSync()))
                              : null);
                      RecipeService.instance.addRecipe(recipe);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget instructionsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: instructions.isNotEmpty
          ? instructions
          .map((e) =>
          Row(
            children: [
              Text(
                  "${e.instruction.substring(0,
                      e.instruction.length > 20 ? 20 : e.instruction
                          .length)} ${e.instruction.length > 20 ? "..." : ""}"),
              if (e.instructionImage != null)
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Icon(CupertinoIcons.paperclip), //TODO Color
                ),
              const Spacer(),
              CupertinoButton(
                  child: const Icon(CupertinoIcons.delete),
                  onPressed: () {
                    setState(() {
                      instructions
                          .removeWhere((element) => element == e);
                    });
                  })
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
          .map((e) =>
          Row(
            children: [
              Text("${e.menge.toString()} "),
              Text("${e.einheit.name.toString()} "),
              Text(e.zutat),
              const Spacer(),
              CupertinoButton(
                  child: const Icon(CupertinoIcons.delete),
                  onPressed: () {
                    setState(() {
                      ingredients
                          .removeWhere((element) => element == e);
                    });
                  })
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
                placeholder: "Zeit",
                keyboardType: TextInputType.phone),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("Minuten bei"),
          ),
          Flexible(
            child: CupertinoTextField(
              controller: temperatureTextController,
              placeholder: "Temperatur",
              maxLines: 1,
            ),
          ),
          Flexible(
            child: CupertinoPicker(
              itemExtent: 25,
              onSelectedItemChanged: (value) {
                _temperatureinheit = Temperatureinheit.values.elementAt(value);
              },
              children: Temperatureinheit.values
                  .map((e) => Text(e.showName))
                  .toList(),
            ),
          ),
          const Text("backen"),
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



