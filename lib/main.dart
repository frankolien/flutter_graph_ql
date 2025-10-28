import 'package:flutter/material.dart';
import 'package:flutter_graph_ql/providers/fetch_character_provider.dart';
import 'package:flutter_graph_ql/providers/fetch_characters_state.dart';
import 'package:flutter_graph_ql/screens/character_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }

}
  class HomeScreen extends ConsumerWidget {
    
    @override
    
    Widget build(BuildContext context, WidgetRef ref) {
      return  Scaffold(
        appBar: AppBar(
          title: Text('Rick and Morty'),
        ),
        
        body: ref.watch(fetchCharacterProvider).maybeWhen(
          initial: () {
            print('State: Initial');
            return Center(child: CircularProgressIndicator());
          },
          loading: () {
            print('State: Loading');
            return Center(child: CircularProgressIndicator());
          },
          success: (characters) {
            print('State: Success with ${characters.length} characters');
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
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
            return Center(child: CircularProgressIndicator());
          },
        ),

        );

    }
  } 
