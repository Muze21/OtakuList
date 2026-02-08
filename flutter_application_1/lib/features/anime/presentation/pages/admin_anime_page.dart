import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/core/utils/responsive_helper.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';
import 'package:flutter_application_1/features/anime/presentation/providers/anime_provider.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/anime_form_modal.dart' as animeFormModal;
import 'dart:io';

class AdminAnimePage extends ConsumerStatefulWidget {
  const AdminAnimePage({super.key});

  @override
  ConsumerState<AdminAnimePage> createState() => _AdminAnimePageState();
}

class _AdminAnimePageState extends ConsumerState<AdminAnimePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final animeAsync = ref.watch(
      allAnimeProvider(
        AnimeFilters(status: 'All', searchQuery: _searchQuery, sortBy: 'title'),
      ),
    );

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
              child: const Icon(Icons.admin_panel_settings_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Admin - Manage Anime'),
          ],
        ),
        actions: [
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
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAnimeModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Anime'),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: animeAsync.when(
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
                // Filter by search query
                final filteredList = _searchQuery.isEmpty
                    ? animeList
                    : animeList
                        .where((anime) =>
                            anime.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            (anime.synopsis ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                if (filteredList.isEmpty) {
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
                          'No anime found',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final anime = filteredList[index];
                    return _AnimeListTile(
                      anime: anime,
                      onEdit: () => _showAnimeModal(context, anime),
                      onDelete: () => _showDeleteDialog(context, anime),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimeModal(BuildContext context, [AnimeModel? anime]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => animeFormModal.AnimeFormModal(
        anime: anime,
        onSuccess: () {
          Navigator.pop(context);
          // Invalidate cache untuk refresh list
          ref.invalidate(allAnimeProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(anime == null ? 'Anime added successfully' : 'Anime updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AnimeModel anime) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Anime'),
        content: Text('Are you sure you want to delete "${anime.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(animeRepositoryProvider).deleteAnime(anime.id);
                ref.invalidate(allAnimeProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anime deleted successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimeListTile extends StatelessWidget {
  final AnimeModel anime;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimeListTile({
    required this.anime,
    required this.onEdit,
    required this.onDelete,
  });

  // Local helper to build ImageProvider safely (handles web cache refs)
  ImageProvider<Object>? _buildImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    // web cached image
    if (imagePath.startsWith('web_image:')) {
      final filename = imagePath.replaceFirst('web_image:', '');
      try {
        if (animeFormModal.webImageCache.containsKey(filename)) return MemoryImage(animeFormModal.webImageCache[filename]!);
      } catch (_) {}
      return null;
    }
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    if (imagePath.startsWith('assets/')) return AssetImage(imagePath);
    // treat as local file
    return FileImage(File(imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
            child: Row(
          children: [
            // Poster thumbnail (Supabase Storage image or icon fallback)
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.surface,
                    image: _buildImageProvider(anime.coverImageUrl) != null
                        ? DecorationImage(image: _buildImageProvider(anime.coverImageUrl)!, fit: BoxFit.cover)
                        : null,
              ),
              child: _buildImageProvider(anime.coverImageUrl) == null
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Anime info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(anime.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          anime.status,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        anime.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${anime.episodes} episodes • ${anime.year}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: AppColors.error,
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
