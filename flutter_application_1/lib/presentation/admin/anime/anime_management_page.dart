// lib/presentation/admin/anime/anime_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeManagementPage extends ConsumerStatefulWidget {
  const AnimeManagementPage({super.key});

  @override
  ConsumerState<AnimeManagementPage> createState() =>
      _AnimeManagementPageState();
}

class _AnimeManagementPageState extends ConsumerState<AnimeManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Management'),
      ),
      body: ListView.builder(
        itemCount: 10, // TODO: Replace with actual data
        itemBuilder: (context, index) {
          return _AnimeManagementItem(
            title: 'Anime Title $index',
            episodes: 12 + index,
            status: index % 2 == 0 ? 'Ongoing' : 'Completed',
            rating: 8.0 + (index * 0.2),
            onEdit: () => _showAnimeDialog(isEdit: true, index: index),
            onDelete: () => _confirmDelete(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAnimeDialog(isEdit: false),
        icon: const Icon(Icons.add),
        label: const Text('Add Anime'),
      ),
    );
  }

  void _showAnimeDialog({required bool isEdit, int? index}) {
    final titleController = TextEditingController();
    final synopsisController = TextEditingController();
    final episodesController = TextEditingController();
    final studioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Anime' : 'Add New Anime'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: synopsisController,
                decoration: const InputDecoration(labelText: 'Synopsis'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: episodesController,
                decoration: const InputDecoration(labelText: 'Episodes'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: studioController,
                decoration: const InputDecoration(labelText: 'Studio'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Ongoing', 'Completed', 'Upcoming']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save anime
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Anime'),
        content: const Text('Are you sure you want to delete this anime?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete anime
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AnimeManagementItem extends StatelessWidget {
  final String title;
  final int episodes;
  final String status;
  final double rating;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimeManagementItem({
    required this.title,
    required this.episodes,
    required this.status,
    required this.rating,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          color: Colors.grey[300],
          child: const Icon(Icons.movie),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Episodes: $episodes'),
            Text('Status: $status'),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onEdit,
              child: const Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: onDelete,
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}