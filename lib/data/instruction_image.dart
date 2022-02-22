import 'package:json_annotation/json_annotation.dart';
import 'package:kochbuch/data/recipe_image.dart';


part 'instruction_image.g.dart';

@JsonSerializable()
class InstructionImage extends RecipeImage{
  InstructionImage({required String base64String}) : super(base64String: base64String);

  factory InstructionImage.fromJson(Map<String, dynamic> json) =>
      _$InstructionImageFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionImageToJson(this);
}