import 'package:dio/dio.dart';
import 'package:flutter_graph_ql/models/character.dart';
import 'package:flutter_graph_ql/providers/fetch_characters_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fetchCharacterProvider = StateNotifierProvider<FetchCharacterProvider, FetchCharactersState>((ref) {
  return FetchCharacterProvider(FetchCharactersState.initial())..fetchCharacters();
});

class FetchCharacterProvider extends StateNotifier<FetchCharactersState> {
  FetchCharacterProvider(super.state);

  Future<void> fetchCharacters() async {
    print('Starting to fetch characters...');
    state = FetchCharactersState.loading();
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      
      print('Sending REST API request...');
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
      );
      
      print('Response received: ${response.statusCode}');
      print('Response keys: ${response.data?.keys}');
       
      List<Character> characters = (response.data['results'] as List)
          .map((e) => Character.fromJson(e))
          .toList();
      print('✅ Parsed ${characters.length} characters');
      state = FetchCharactersState.success(characters);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      state = FetchCharactersState.error('DioException: ${e.message}');
    }
    catch (e, stackTrace) {
      print(' General exception: $e');
      print(' Stack trace: $stackTrace');
      state = FetchCharactersState.error('Error: $e');
    }
  }

}