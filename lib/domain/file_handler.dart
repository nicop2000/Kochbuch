import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kochbuch/data/recipe.dart';

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


}