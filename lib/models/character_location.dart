import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_location.freezed.dart';

@freezed
abstract class CharacterLocation with _$CharacterLocation {
  const CharacterLocation._();
  
  const factory CharacterLocation({
    String? id,
    String? name,
  }) = _CharacterLocation;

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      id: json['id']?.toString(),
      name: json['name'] as String?,
    );
  }
}

