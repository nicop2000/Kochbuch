// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instruction _$InstructionFromJson(Map<String, dynamic> json) => Instruction(
      instruction: json['instruction'] as String,
      instructionImage: json['instructionImage'] == null
          ? null
          : InstructionImage.fromJson(
              json['instructionImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InstructionToJson(Instruction instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'instructionImage': instance.instructionImage,
    };
