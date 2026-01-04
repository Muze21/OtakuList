// lib/presentation/anime/list/anime_list_page.dart
import 'package:flutter/material.dart';
import 'anime_list_view.dart';

class AnimeListPage extends StatelessWidget {
  const AnimeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Anime'),
      ),
      body: const SafeArea(
        child: AnimeListView(),
      ),
    );
  }
}