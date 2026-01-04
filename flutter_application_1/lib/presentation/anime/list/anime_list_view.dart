// lib/presentation/anime/list/anime_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/domain/anime_card.dart';
import '../../../core/themes/colors.dart';
import '../../../core/utils/debouncer.dart';
import 'anime_list_controller.dart';

class AnimeListView extends ConsumerStatefulWidget {
  const AnimeListView({super.key});

  @override
  ConsumerState<AnimeListView> createState() => _AnimeListViewState();
}

class _AnimeListViewState extends ConsumerState<AnimeListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    
    // Load initial data
    Future.microtask(() {
      ref.read(animeListControllerProvider.notifier).loadAnimes(refresh: true);
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(animeListControllerProvider.notifier).loadAnimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(animeListControllerProvider);

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search anime...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(animeListControllerProvider.notifier)
                            .search('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              _debouncer(() {
                ref.read(animeListControllerProvider.notifier).search(value);
              });
            },
          ),
        ),

        // Genre Filter (optional - tambahkan nanti)
        // GenreFilterRow(),

        // Anime Grid
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.error}',
                            style: const TextStyle(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(animeListControllerProvider.notifier)
                                  .loadAnimes(refresh: true);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : state.animes.isEmpty
                      ? const Center(
                          child: Text('No anime found'),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await ref
                                .read(animeListControllerProvider.notifier)
                                .loadAnimes(refresh: true);
                          },
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: state.animes.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Loading indicator at the end
                              if (index == state.animes.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final anime = state.animes[index];
                              return AnimeCard(
                                anime: anime,
                                onTap: () {
                                  context.push('/anime/${anime.id}');
                                },
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}