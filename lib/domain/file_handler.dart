import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:open_file/open_file.dart';

import '';

import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kochbuch/data/recipe.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FileHandler {

  Recipe acceptFileForSingle({required File file}) {
    Map<String, dynamic> jsonObject = _fileToSingleJsonObject(file: file);
    return Recipe.fromJson(jsonObject);
  }

  Map<String, dynamic> _fileToSingleJsonObject({required File file}) {
    String importedJsonString = file.readAsStringSync();
    return jsonDecode(importedJsonString);
  }

  List<Recipe> acceptFileForCollection({required File file}) {
    List<dynamic> jsonObject = _fileToCollectionJsonObject(file: file);
    return jsonObject.map((e) => Recipe.fromJson(e)).toList();
  }

  List<dynamic> _fileToCollectionJsonObject({required File file}) {
    String importedJsonString = file.readAsStringSync();
    var b = jsonDecode(importedJsonString);
    return b;
  }

  Future<void> shareRecipeAsJSON(Recipe recipe) async {
    Directory temporaryDirectory = await getTemporaryDirectory();

    String path =
        '${temporaryDirectory.path}/recipe-${recipe.title}-ID_${recipe.id}.json';
    File file = await File(path).create();
    file.writeAsStringSync(jsonEncode(recipe.toJson()));

    await FlutterShare.shareFile(
        fileType: 'application/json', title: recipe.title, filePath: file.path);
  }

  Future<void> shareCookbookAsJSON({required String cookbook, required int cookbookLength}) async {
    Directory temporaryDirectory = await getTemporaryDirectory();

    String path = '${temporaryDirectory.path}/recipe-collection-'
        'size-$cookbookLength-'
        'date-${DateTime.now().toLocal()}.json';
    File file = await File(path).create();
    file.writeAsStringSync(cookbook);

    await FlutterShare.shareFile(
        fileType: 'application/json',
        title: path.split('/').last,
        filePath: file.path);
  }

  Future<void> shareRecipeAsPDF({required String title, required int id, required List<int> recipeBytes}) async {
    Directory temporaryDirectory = await getTemporaryDirectory();

    String path =
        '${temporaryDirectory.path}/recipe-$title-ID_$id.pdf';
    File file = await File(path).create();
    file.writeAsBytesSync(recipeBytes);
    OpenFile.open(path);
    // await FlutterShare.shareFile(fileType: 'application/pdf', title: title, filePath: file.path);
  }





}