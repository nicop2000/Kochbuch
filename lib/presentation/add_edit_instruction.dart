import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/instruction_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kochbuch/common.dart';

class AddEditInstruction extends StatefulWidget {
  const AddEditInstruction({Key? key, required this.onPressed, this.instruction}) : super(key: key);

  final Function(Instruction) onPressed;
  final Instruction? instruction;

  @override
  State<AddEditInstruction> createState() => _AddEditInstructionState();
}

class _AddEditInstructionState extends State<AddEditInstruction> {
  final TextEditingController anweisungTextController = TextEditingController();

  File? image;

  final picker = ImagePicker();

  double size = 512;
  bool first = true;
  String buttonText = "";
  String titleText = "";
  @override
  Widget build(BuildContext context) {
    if(first && widget.instruction != null) prepareForEditing();
    else if (widget.instruction == null) {
      buttonText = AppLocalizations.of(context)!.hinzufuegen_button_text;
      titleText = AppLocalizations.of(context)!.neuer_zubereitungsschritt_page_title;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoTextField(
                  controller: anweisungTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 5,
                ),
                CupertinoButton(
                    child: Text(AppLocalizations.of(context)!.bild_hinzufuegen_button_text,
                      style: Theme.of(context).textTheme.button),
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return CupertinoAlertDialog(
                              title: Text(AppLocalizations.of(context)!.bildquelle_auswaehlen_title, style: Theme.of(context).textTheme.headline2,),
                              content: Column(
                                children:  [
                                  Text(
                                      AppLocalizations.of(context)!.bildquelle_auswaehlen_text, style: Theme.of(context).textTheme.bodyText1),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child:
                                      Text(AppLocalizations.of(context)!.bildquelle_galerie_button_text, style: Theme.of(context).textTheme.button),
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
                                      Text(AppLocalizations.of(context)!.bildquelle_kamera_button_text, style: Theme.of(context).textTheme.button),
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
                                  Text(AppLocalizations.of(context)!.abbrechen_button_text, style: Theme.of(context).textTheme.button),
                                  onPressed: () async => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          });
                    }),
                if(image != null)
                Column(
                  children: [
                    Image.file(
                      image!,
                      height: 200,
                    ),
                    CupertinoButton(child: Text(AppLocalizations.of(context)!.rezept_bild_loeschen, style: Theme.of(context).textTheme.button), onPressed: () {
                      setState(() {
                        image = null;
                      });
                    })
                  ],
                ),
                CupertinoButton(
                  child: Text(buttonText,
                      style: Theme.of(context).textTheme.button),
                  onPressed: () {
                    Instruction i = Instruction(
                        instruction: anweisungTextController.text,
                        instructionImage: image != null
                            ? InstructionImage(
                                base64String:
                                base64Encode(image!.readAsBytesSync()))
                            : null);
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

  Future<void> prepareForEditing() async {
    first = false;
    anweisungTextController.text = widget.instruction!.instruction;
    if (widget.instruction!.instructionImage != null) {
      getTemporaryDirectory().then((value) async {
      Uint8List imageInUnit8List = base64Decode(widget.instruction!.instructionImage!.base64String);// store unit8List image here ;
        File file = await File('${value.path}/image.png').create();
        file.writeAsBytesSync(imageInUnit8List);
        setState(() {
        image = file;
        });
      });
    }
    buttonText = AppLocalizations.of(context)!.speichern_button_text;
    titleText = AppLocalizations.of(context)!.zubereitungsschritt_edit_page_title;
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
