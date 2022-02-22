import 'package:json_annotation/json_annotation.dart';


part 'recipe_image.g.dart';

@JsonSerializable()
class RecipeImage {

  String base64String;

  RecipeImage({required this.base64String});

  factory RecipeImage.fromJson(Map<String, dynamic> json) =>
      _$RecipeImageFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeImageToJson(this);
}