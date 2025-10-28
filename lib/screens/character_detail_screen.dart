import 'package:flutter/material.dart';
import 'package:flutter_graph_ql/models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;
  
  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character Image
            SizedBox(
              width: double.infinity,
              height: 300,

              child: Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    character.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 100);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Character Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Name', character.name),
                  if (character.status != null)
                    _buildDetailRow('Status', character.status!),
                  if (character.species != null)
                    _buildDetailRow('Species', character.species!),
                  if (character.location?.name != null)
                    _buildDetailRow('Location', character.location!.name!),
                  if (character.origin?.name != null)
                    _buildDetailRow('Origin', character.origin!.name!),
                  if (character.created != null)
                    _buildDetailRow('Created', character.created!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

