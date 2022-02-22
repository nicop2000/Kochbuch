// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      title: json['title'] as String,
      description: json['description'] as String?,
      abteilung: $enumDecode(_$AbteilungEnumMap, 'brot'), //TODO: json['abteilung'].toString().toLowerCase()
      backanweisung: json['backanweisung'] == null
          ? null
          : Backanweisung.fromJson(
              json['backanweisung'] as Map<String, dynamic>),
      fav: json['fav'] as bool,
      id: json['id'] as int,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => Instruction.fromJson(e as Map<String, dynamic>))
          .toList(),
      link: json['link'] as String?,
      image: json['image'] == null
          ? null
          : RecipeImage.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'abteilung': _$AbteilungEnumMap[instance.abteilung],
      'backanweisung': instance.backanweisung,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'link': instance.link,
      'image': instance.image,
      'fav': instance.fav,
    };

const _$AbteilungEnumMap = {
  Abteilung.fruehstueck: 'fruehstueck',
  Abteilung.mittagessen: 'mittagessen',
  Abteilung.abendessen: 'abendessen',
  Abteilung.dessert: 'dessert',
  Abteilung.torte: 'torte',
  Abteilung.kuchen: 'kuchen',
  Abteilung.kekse: 'kekse',
  Abteilung.gebaeck: 'gebaeck',
  Abteilung.salate: 'salate',
  Abteilung.brot: 'brot',
  Abteilung.cocktail: 'cocktail',
  Abteilung.sonstiges: 'sonstiges',
};
