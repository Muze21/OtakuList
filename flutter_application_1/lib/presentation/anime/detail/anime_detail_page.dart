// lib/presentation/anime/detail/anime_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'anime_detail_view.dart';
import 'anime_detail_controller.dart';

class AnimeDetailPage extends ConsumerStatefulWidget {
  final String animeId;

  const AnimeDetailPage({
    super.key,
    required this.animeId,
  });

  @override
  ConsumerState<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends ConsumerState<AnimeDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load anime detail on page load
    Future.microtask(() {
      ref
          .read(animeDetailControllerProvider(widget.animeId).notifier)
          .loadAnimeDetail(widget.animeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(animeDetailControllerProvider(widget.animeId));

    return Scaffold(
      appBar: AppBar(
        title: Text(state.anime?.title ?? 'Anime Detail'),
        actions: [
          // Add more actions here (share, favorite, etc)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimeDetailView(animeId: widget.animeId),
      ),
    );
  }
}