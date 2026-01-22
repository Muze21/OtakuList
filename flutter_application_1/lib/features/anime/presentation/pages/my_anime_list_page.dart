import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/core/utils/responsive_helper.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/anime_card.dart';

class MyAnimeListPage extends StatefulWidget {
  const MyAnimeListPage({super.key});

  @override
  State<MyAnimeListPage> createState() => _MyAnimeListPageState();
}

class _MyAnimeListPageState extends State<MyAnimeListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // TODO: Replace with real data from Supabase
  List<UserAnimeList> _getDummyAnimeList() {
    return [
      UserAnimeList(
        id: 1,
        animeId: 1,
        anime: Anime(
          id: 1,
          title: 'Attack on Titan',
          synopsis: 'Humanity fights for survival against giant Titans',
          coverImageUrl: 'https://cdn.myanimelist.net/images/anime/10/47347.jpg',
          status: 'completed',
          totalEpisodes: 75,
          avgRating: 9.0,
          genres: ['Action', 'Drama', 'Fantasy'],
          studio: 'MAPPA',
        ),
        listStatus: 'watching',
        progressEpisode: 45,
        score: 9,
        isFavorite: true,
      ),
      UserAnimeList(
        id: 2,
        animeId: 2,
        anime: Anime(
          id: 2,
          title: 'Demon Slayer',
          synopsis: 'A boy becomes a demon slayer to save his sister',
          coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1286/99889.jpg',
          status: 'ongoing',
          totalEpisodes: 26,
          avgRating: 8.7,
          genres: ['Action', 'Supernatural'],
          studio: 'ufotable',
        ),
        listStatus: 'completed',
        progressEpisode: 26,
        score: 8,
        isFavorite: false,
      ),
      UserAnimeList(
        id: 3,
        animeId: 3,
        anime: Anime(
          id: 3,
          title: 'Jujutsu Kaisen',
          synopsis: 'A high school student joins a secret organization',
          coverImageUrl: 'https://cdn.myanimelist.net/images/anime/1171/109222.jpg',
          status: 'ongoing',
          totalEpisodes: 24,
          avgRating: 8.8,
          genres: ['Action', 'Supernatural'],
          studio: 'MAPPA',
        ),
        listStatus: 'watching',
        progressEpisode: 12,
        score: null,
        isFavorite: true,
      ),
      UserAnimeList(
        id: 4,
        animeId: 4,
        anime: Anime(
          id: 4,
          title: 'My Hero Academia',
          synopsis: 'A world where people have superpowers',
          coverImageUrl: 'https://cdn.myanimelist.net/images/anime/10/78745.jpg',
          status: 'ongoing',
          totalEpisodes: 113,
          avgRating: 7.9,
          genres: ['Action', 'Comedy'],
          studio: 'Bones',
        ),
        listStatus: 'planned',
        progressEpisode: 0,
        score: null,
        isFavorite: false,
      ),
    ];
  }

  List<UserAnimeList> _getFilteredAnime(String status) {
    var animeList = _getDummyAnimeList();
    
    // Filter by status
    if (status != 'all') {
      animeList = animeList.where((anime) => anime.listStatus == status).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      animeList = animeList.where((anime) {
        return anime.anime.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return animeList;
  }



  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Anime List'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile coming soon!')),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textHint,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textHint,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: !isDesktop,
                onTap: (index) {
                  setState(() {});
                },
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Watching'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Planned'),
                  Tab(text: 'Dropped'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnimeGrid('watching', isDesktop),
          _buildAnimeGrid('completed', isDesktop),
          _buildAnimeGrid('planned', isDesktop),
          _buildAnimeGrid('dropped', isDesktop),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to search/add anime
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add anime coming soon!')),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(
          'Add Anime',
          style: AppTextStyles.button.copyWith(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildAnimeGrid(String status, bool isDesktop) {
    final animeList = _getFilteredAnime(status);

    if (animeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No anime found'
                  : 'No anime in this list',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Start adding anime to your list!',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : (ResponsiveHelper.isTablet(context) ? 3 : 2),
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: animeList.length,
      itemBuilder: (context, index) {
        return AnimeCard(
          userAnime: animeList[index],
          onTap: () {
            // TODO: Navigate to anime detail
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${animeList[index].anime.title}'),
              ),
            );
          },
        );
      },
    );
  }
}