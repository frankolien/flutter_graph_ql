import 'package:flutter/material.dart';
import 'package:flutter_graph_ql/providers/fetch_character_provider.dart';
import 'package:flutter_graph_ql/providers/fetch_characters_state.dart';
import 'package:flutter_graph_ql/screens/character_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when user scrolls to 80% of the list
      ref.read(fetchCharacterProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
      ),
      
      body: ref.watch(fetchCharacterProvider).maybeWhen(
        initial: () {
          print('State: Initial');
          return const Center(child: CircularProgressIndicator());
        },
        loading: () {
          print('State: Loading');
          return const Center(child: CircularProgressIndicator());
        },
        success: (characters, hasMore, page) {
          print('State: Success with ${characters.length} characters');
          return ListView.builder(
            controller: _scrollController,
            itemCount: hasMore ? characters.length + 1 : characters.length,
            itemBuilder: (context, index) {
              if (index == characters.length) {
                // Show loading indicator at the bottom when loading more
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              final character = characters[index];
              return ListTile(
                title: Text(character.name),
                subtitle: Text(character.status ?? ''),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(character.image ?? ''),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterDetailScreen(
                        character: character,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        error: (message) {
          print('State: Error - $message');
          return Center(child: Text('Error: $message'));
        },
        orElse: () {
          print('State: orElse (fallback)');
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
