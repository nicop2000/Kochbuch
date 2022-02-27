// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeImage _$RecipeImageFromJson(Map<String, dynamic> json) {
  String imgData = json['base64String'] as String;
  // print(imgData.length); //TODO reset
  // log(imgData);
  return RecipeImage(
    base64String: imgData
  );
}

Map<String, dynamic> _$RecipeImageToJson(RecipeImage instance) =>
    <String, dynamic>{
      'base64String': instance.base64String,
    };
