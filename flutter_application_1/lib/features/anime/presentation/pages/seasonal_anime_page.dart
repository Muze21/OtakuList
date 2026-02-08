import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/core/utils/responsive_helper.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/seasonal_anime_card.dart';
import 'package:flutter_application_1/features/anime/presentation/providers/anime_provider.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';
import 'package:flutter_application_1/features/anime/data/models/season_model.dart';

class SeasonalAnimePage extends ConsumerStatefulWidget {
  const SeasonalAnimePage({super.key});

  @override
  ConsumerState<SeasonalAnimePage> createState() => _SeasonalAnimePageState();
}

class _SeasonalAnimePageState extends ConsumerState<SeasonalAnimePage> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _sortOptions = ['rating', 'popularity', 'title'];
  final List<String> _statusFilters = ['All', 'Ongoing', 'Completed', 'Upcoming'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AnimeCard _convertToAnimeCard(AnimeModel anime) {
    return AnimeCard(
      id: anime.id.hashCode,
      title: anime.title,
      coverImageUrl: '',
      releaseDate: '${anime.year}',
      episodeCount: anime.episodes,
      durationMinutes: 24,
      genres: anime.genres,
      synopsis: anime.synopsis ?? '',
      studio: anime.studio ?? '',
      avgRating: anime.rating,
      totalRatings: 0,
      type: 'TV',
      status: anime.status.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final filters = ref.watch(animeFiltersProvider);
    final animeAsync = ref.watch(filteredAnimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie_filter_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('MyanimeList'),
          ],
        ),
        actions: [
          // Search Bar (Desktop only)
          if (isDesktop)
            Container(
              width: 300,
              margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(animeFiltersProvider.notifier).setSearchQuery(value);
                },
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search anime...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
              ),
            ),
          
          // Profile Menu
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value clicked')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Mobile Search
          if (!isDesktop)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(animeFiltersProvider.notifier).setSearchQuery(value);
                },
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search anime...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: filters.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                            ref.read(animeFiltersProvider.notifier).setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Sort & Filter Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Sort Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: filters.sortBy,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.sort, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    items: _sortOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(
                          'Sort by ${option[0].toUpperCase()}${option.substring(1)}',
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(animeFiltersProvider.notifier).setSortBy(value);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Status Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: filters.status,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.filter_list, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    items: _statusFilters.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          'Status: $status',
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(animeFiltersProvider.notifier).setStatus(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Anime Grid
          Expanded(
            child: _buildAnimeGrid(context, isDesktop, animeAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeGrid(BuildContext context, bool isDesktop, AsyncValue<List<AnimeModel>> animeAsync) {
    return animeAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading anime',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (animeList) {
        if (animeList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text(
                  'No anime found',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 4 : (ResponsiveHelper.isTablet(context) ? 3 : 2),
            childAspectRatio: 0.48,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: animeList.length,
          itemBuilder: (context, index) {
            final anime = animeList[index];
            return SeasonalAnimeCard(
              anime: _convertToAnimeCard(anime),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${anime.title}'),
                  ),
                );
              },
              onAddToList: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added ${anime.title} to list'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
