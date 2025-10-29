import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_graph_ql/models/character.dart';

part 'fetch_characters_state.freezed.dart';


@freezed
class FetchCharactersState with _$FetchCharactersState {
  factory FetchCharactersState.initial() = _Initial;
  factory FetchCharactersState.loading() = _Loading;
  factory FetchCharactersState.success({
    required List<Character> characters,
    required bool hasMore,
    required int page,
  }) = _Success;
  factory FetchCharactersState.error(String message) = _Error;
} 