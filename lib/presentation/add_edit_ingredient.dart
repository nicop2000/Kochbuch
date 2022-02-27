import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kochbuch/base/Ext.dart';
import 'package:kochbuch/data/ingredient.dart';
import 'package:kochbuch/data/mengen_einheit.dart';
import 'package:kochbuch/common.dart';

class AddEditIngredient extends StatefulWidget {
  const AddEditIngredient({Key? key, required this.onPressed, this.ingredient}) : super(key: key);

  final Function(Ingredient) onPressed;
  final Ingredient? ingredient;

  @override
  State<AddEditIngredient> createState() => _AddEditIngredientState();
}

class _AddEditIngredientState extends State<AddEditIngredient> {
  final TextEditingController mengenTextController = TextEditingController();
  final TextEditingController zutatenTextController = TextEditingController();
  MengenEinheit _mengenEinheit = MengenEinheit.g;
  String buttonText = "";
  String titleText = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    if(first && widget.ingredient != null) prepareForEditing();
    else if(widget.ingredient == null) {
      buttonText = AppLocalizations.of(context)!.hinzufuegen_button_text;
      titleText = AppLocalizations.of(context)!.neue_zutat_page_title;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText, style: Theme.of(context).textTheme.headline1,),
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

                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: CupertinoTextField(
                          controller: mengenTextController,
                          style: Theme.of(context).textTheme.bodyText1,
                          placeholder: AppLocalizations.of(context)!.menge_placeholder,
                          keyboardType: TextInputType.phone),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 60,
                        child: CupertinoPicker(
                            itemExtent: 25,
                            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                              background: Theme.of(context).colorScheme.primaryVariant,
                            ),
                            onSelectedItemChanged: (value) {
                              _mengenEinheit =
                                  MengenEinheit.values.elementAt(value);
                            },
                            children: MengenEinheit.values
                                .map((e) => Text(e.showName, style: Theme.of(context).textTheme.bodyText2,),)
                                .toList()),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: CupertinoTextField(
                        controller: zutatenTextController,
                        style: Theme.of(context).textTheme.bodyText1,
                        placeholder: AppLocalizations.of(context)!.zutat_name_placeholder,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                CupertinoButton(
                  child: Text(buttonText, style: Theme.of(context).textTheme.button,),
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

  void prepareForEditing() {
    first = false;
    mengenTextController.text = widget.ingredient!.menge.toString();
    zutatenTextController.text = widget.ingredient!.zutat;
    _mengenEinheit = widget.ingredient!.einheit;
    buttonText = AppLocalizations.of(context)!.speichern_button_text;
    titleText = AppLocalizations.of(context)!.zutat_edit_page_title;
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
