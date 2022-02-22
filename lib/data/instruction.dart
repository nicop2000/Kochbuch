import 'package:json_annotation/json_annotation.dart';
import 'package:kochbuch/data/instruction_image.dart';

part 'instruction.g.dart';

@JsonSerializable()
class Instruction{

  String instruction;
  InstructionImage? instructionImage;

  Instruction({required this.instruction, this.instructionImage});

  factory Instruction.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);
}