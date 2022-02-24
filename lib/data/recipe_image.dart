import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


part 'recipe_image.g.dart';

@JsonSerializable()
class RecipeImage {

  String base64String;

  RecipeImage({required this.base64String});

  Image asImage({double height = 200}) {
    return Image.memory(base64Decode(base64String), height: height,);
  }

  factory RecipeImage.fromJson(Map<String, dynamic> json) =>
      _$RecipeImageFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeImageToJson(this);
}