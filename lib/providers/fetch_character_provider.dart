import 'package:dio/dio.dart';
import 'package:flutter_graph_ql/models/character.dart';
import 'package:flutter_graph_ql/providers/fetch_characters_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fetchCharacterProvider = StateNotifierProvider<FetchCharacterProvider, FetchCharactersState>((ref) {
  return FetchCharacterProvider(FetchCharactersState.initial())..fetchCharacters();
});

class FetchCharacterProvider extends StateNotifier<FetchCharactersState> {
  FetchCharacterProvider(super.state);

  int _currentPage = 0;
  int _totalPages = 0;
  List<Character> _characters = [];
  bool _isLoadingMore = false;

  Future<void> fetchCharacters() async {
    print('Starting to fetch characters...');
    state = FetchCharactersState.loading();
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      
      _currentPage = 1;
      print('Fetching page 1...');
      final response = await dio.get('https://rickandmortyapi.com/api/character');
      
      final info = response.data['info'];
      _totalPages = info['pages'] as int;
      print('Total pages: $_totalPages');
      
      _characters = (response.data['results'] as List)
          .map((e) => Character.fromJson(e))
          .toList();
      
      print('✅ Parsed ${_characters.length} characters');
      state = FetchCharactersState.success(
        characters: _characters,
        hasMore: _currentPage < _totalPages,
        page: _currentPage,
      );
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

  Future<void> loadMoreCharacters() async {
    if (_isLoadingMore) return;
    
    state.maybeWhen(
      success: (characters, hasMore, page) async {
        if (!hasMore) return;
        
        _isLoadingMore = true;
        try {
          Dio dio = Dio();
          dio.options.headers['Content-Type'] = 'application/json';
          
          _currentPage++;
          print('Loading page $_currentPage...');
          final response = await dio.get('https://rickandmortyapi.com/api/character?page=$_currentPage');
          
          final newCharacters = (response.data['results'] as List)
              .map((e) => Character.fromJson(e))
              .toList();
          
          _characters = [..._characters, ...newCharacters];
          
          print('✅ Loaded ${newCharacters.length} more characters. Total: ${_characters.length}');
          
          state = FetchCharactersState.success(
            characters: _characters,
            hasMore: _currentPage < _totalPages,
            page: _currentPage,
          );
        } catch (e) {
          print('Error loading more: $e');
        } finally {
          _isLoadingMore = false;
        }
      },
      orElse: () {},
    );
  }
}
