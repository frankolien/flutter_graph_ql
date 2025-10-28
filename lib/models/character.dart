import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_graph_ql/models/character_location.dart';

part 'character.freezed.dart';

@freezed
abstract class Character with _$Character {
  const Character._();
  
  const factory Character({
    required String id,
    required String name,
    String? status,
    String? image,
    String? species,
    String? created,
    CharacterLocation? location,
    CharacterLocation? origin,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) {
    // Handle id conversion (could be int or String from API)
    final id = json['id']?.toString() ?? '';
    return Character(
      id: id,
      name: json['name'] as String,
      status: json['status'] as String?,
      image: json['image'] as String?,
      species: json['species'] as String?,
      created: json['created'] as String?,
      location: json['location'] != null ? CharacterLocation.fromJson(json['location']) : null,
      origin: json['origin'] != null ? CharacterLocation.fromJson(json['origin']) : null,
    );
  }
}
