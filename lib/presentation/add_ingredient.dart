import 'dart:io';
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kochbuch/data/ingredient.dart';
import 'package:kochbuch/data/mengen_einheit.dart';

class AddIngredient extends StatefulWidget {
  const AddIngredient({Key? key, required this.onPressed}) : super(key: key);

  final Function(Ingredient) onPressed;

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  final TextEditingController mengenTextController = TextEditingController();
  final TextEditingController zutatenTextController = TextEditingController();
  MengenEinheit _mengenEinheit = MengenEinheit.g;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Zutat hinzufügen"),
        backgroundColor: CupertinoColors.systemRed,
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: CupertinoTextField(
                          controller: mengenTextController,
                          placeholder: "Menge",
                          keyboardType: TextInputType.phone),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 60,
                        child: CupertinoPicker(
                            itemExtent: 25,
                            onSelectedItemChanged: (value) {
                              _mengenEinheit =
                                  MengenEinheit.values.elementAt(value);
                            },
                            children: MengenEinheit.values
                                .map((e) => Text(e.name))
                                .toList()),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: CupertinoTextField(
                        controller: zutatenTextController,
                        placeholder: "Name",
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                CupertinoButton(
                  child: const Text("Hinzufügen"),
                  onPressed: () {
                    Ingredient i = Ingredient(
                        menge: int.tryParse(mengenTextController.text) ?? 0,
                        zutat: zutatenTextController.text,
                        einheit: _mengenEinheit);

                    widget.onPressed(i);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
DropdownButton<MengenEinheit>(
                  focusColor:Colors.white,
                  value: _mengenEinheit,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: MengenEinheit.values.map<DropdownMenuItem<MengenEinheit>>((MengenEinheit value) {
                    return DropdownMenuItem<MengenEinheit>(
                      value: value,
                      child: Text(value.name,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint: Text(
                    "Bitte wähle eine Mengeneinheit aus",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (MengenEinheit? value) {
                    setState(() {
                      _mengenEinheit = value!;
                    });
                  },
                ),
 */
