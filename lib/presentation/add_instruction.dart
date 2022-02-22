import 'dart:io';
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kochbuch/data/instruction.dart';
import 'package:kochbuch/data/instruction_image.dart';

class AddInstruction extends StatefulWidget {
  AddInstruction({Key? key, required this.onPressed}) : super(key: key);

  final Function(Instruction) onPressed;

  @override
  State<AddInstruction> createState() => _AddInstructionState();
}

class _AddInstructionState extends State<AddInstruction> {
  final TextEditingController anweisungTextController = TextEditingController();

  File? image;

  final picker = ImagePicker();

  double size = 512;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Anweisung hinzufügen"),
        backgroundColor: CupertinoColors.systemRed,
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text("Neuen Schritt hinzufügen "),
                ),
                CupertinoTextField(
                  controller: anweisungTextController,
                  maxLines: 5,
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
                                      const Text("Bild von Kamera auswählen"),
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
                                  onPressed: () async => Navigator.of(context).pop(),
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
                CupertinoButton(
                  child: const Text("Fertigstellen"),
                  onPressed: () {
                    Instruction i = Instruction(
                        instruction: anweisungTextController.text,
                        instructionImage: image != null
                            ? InstructionImage(
                                base64String:
                                    image!.readAsBytesSync().toString())
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
