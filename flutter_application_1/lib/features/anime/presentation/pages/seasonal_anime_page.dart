import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/core/utils/responsive_helper.dart';
import 'package:flutter_application_1/features/anime/data/models/season_model.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/seasonal_anime_card.dart';

class SeasonalAnimePage extends StatefulWidget {
  const SeasonalAnimePage({super.key});

  @override
  State<SeasonalAnimePage> createState() => _SeasonalAnimePageState();
}

class _SeasonalAnimePageState extends State<SeasonalAnimePage> {
  final TextEditingController _searchController = TextEditingController();
  
  int _selectedSeasonIndex = 0;
  String _selectedType = 'All';
  String _sortBy = 'Rating';
  String _filterStatus = 'All';
  String _searchQuery = '';

  final List<String> _types = ['All', 'TV', 'ONA', 'OVA', 'Movie', 'Special'];
  final List<String> _sortOptions = ['Rating', 'Popularity', 'Title'];
  final List<String> _statusFilters = ['All', 'Ongoing', 'Completed', 'Upcoming'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // TODO: Replace with real Supabase data
  List<AnimeCard> _getDummyAnimeList() {
    return [
      AnimeCard(
        id: 1,
        title: 'Frieren: Beyond Journey\'s End',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1015/138006.jpg',
        releaseDate: 'Sep 2024',
        episodeCount: 28,
        durationMinutes: 24,
        genres: ['Adventure', 'Drama', 'Fantasy'],
        synopsis: 'An elf mage and her former hero companions reunite for a new journey to bid their final farewells and come to terms with the past.',
        studio: 'Madhouse',
        avgRating: 9.2,
        totalRatings: 450000,
        type: 'TV',
        status: 'ongoing',
      ),
      AnimeCard(
        id: 2,
        title: 'Dandadan',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1071/146059.jpg',
        releaseDate: 'Oct 2024',
        episodeCount: 12,
        durationMinutes: 24,
        genres: ['Action', 'Comedy', 'Supernatural'],
        synopsis: 'A high school girl passionate about the occult and an occult-obsessed boy fight against supernatural forces.',
        studio: 'Science SARU',
        avgRating: 8.5,
        totalRatings: 180000,
        type: 'TV',
        status: 'ongoing',
      ),
      AnimeCard(
        id: 3,
        title: 'Blue Lock Season 2',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1756/144481.jpg',
        releaseDate: 'Oct 2024',
        episodeCount: 14,
        durationMinutes: 24,
        genres: ['Sports', 'Action'],
        synopsis: 'The next stage of the Blue Lock project begins with new challenges and fierce competition among strikers.',
        studio: 'Eight Bit',
        avgRating: 8.0,
        totalRatings: 250000,
        type: 'TV',
        status: 'ongoing',
      ),
      AnimeCard(
        id: 4,
        title: 'Re:Zero Season 3',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1178/144374.jpg',
        releaseDate: 'Oct 2024',
        episodeCount: 16,
        durationMinutes: 29,
        genres: ['Drama', 'Fantasy', 'Thriller'],
        synopsis: 'Subaru faces new challenges and mysteries in the Sanctuary as he continues his quest to save those he cares about.',
        studio: 'White Fox',
        avgRating: 8.8,
        totalRatings: 320000,
        type: 'TV',
        status: 'ongoing',
      ),
      AnimeCard(
        id: 5,
        title: 'Mushoku Tensei Season 2 Part 2',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1028/142308.jpg',
        releaseDate: 'Jul 2024',
        episodeCount: 12,
        durationMinutes: 23,
        genres: ['Adventure', 'Drama', 'Fantasy'],
        synopsis: 'Rudeus continues his journey through the magical world, facing new challenges and reuniting with old friends.',
        studio: 'Studio Bind',
        avgRating: 8.7,
        totalRatings: 280000,
        type: 'TV',
        status: 'completed',
      ),
      AnimeCard(
        id: 6,
        title: 'Spy x Family Code: White',
        coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1506/140763.jpg',
        releaseDate: 'Dec 2024',
        episodeCount: 1,
        durationMinutes: 110,
        genres: ['Action', 'Comedy'],
        synopsis: 'The Forger family embarks on a winter vacation that turns into an action-packed adventure.',
        studio: 'Wit Studio',
        avgRating: 8.3,
        totalRatings: 150000,
        type: 'Movie',
        status: 'completed',
      ),
    ];
  }

  List<AnimeCard> _getFilteredAnime() {
    var animeList = _getDummyAnimeList();

    // Filter by type
    if (_selectedType != 'All') {
      animeList = animeList.where((anime) => anime.type == _selectedType).toList();
    }

    // Filter by status
    if (_filterStatus != 'All') {
      animeList = animeList.where((anime) {
        return anime.status.toLowerCase() == _filterStatus.toLowerCase();
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      animeList = animeList.where((anime) {
        return anime.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            anime.genres.any((g) => g.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Rating':
        animeList.sort((a, b) => b.avgRating.compareTo(a.avgRating));
        break;
      case 'Popularity':
        animeList.sort((a, b) => b.totalRatings.compareTo(a.totalRatings));
        break;
      case 'Title':
        animeList.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return animeList;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

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
            const Text('AnimeTracker'),
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
                  setState(() {
                    _searchQuery = value;
                  });
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
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search anime...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
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
                    value: _sortBy,
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
                          'Sort by $option',
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Status Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filterStatus,
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
                      setState(() {
                        _filterStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Anime Grid
          Expanded(
            child: _buildAnimeGrid(isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeGrid(bool isDesktop) {
    final animeList = _getFilteredAnime();

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
        return SeasonalAnimeCard(
          anime: animeList[index],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${animeList[index].title}'),
              ),
            );
          },
          onAddToList: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added ${animeList[index].title} to list'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }
}