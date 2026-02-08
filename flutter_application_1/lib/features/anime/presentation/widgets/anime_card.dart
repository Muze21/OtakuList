import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/anime_form_modal.dart' as animeFormModal;
import 'dart:io';

class AnimeCard extends StatelessWidget {
  final UserAnimeList userAnime;
  final VoidCallback? onTap;

  const AnimeCard({
    super.key,
    required this.userAnime,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (userAnime.listStatus) {
      case 'watching':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      case 'planned':
        return AppColors.warning;
      case 'dropped':
        return AppColors.error;
      default:
        return AppColors.textHint;
    }
  }

  String _getStatusLabel() {
    switch (userAnime.listStatus) {
      case 'watching':
        return 'Watching';
      case 'completed':
        return 'Completed';
      case 'planned':
        return 'Plan to Watch';
      case 'dropped':
        return 'Dropped';
      default:
        return userAnime.listStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get cover image URL from entity (returns Supabase URL, web cache ref, or local path)
    final imageUrl = userAnime.anime.coverImageUrl;
    final imageProvider = _buildImageProvider(imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: AppColors.surfaceLight,
                    image: imageProvider != null
                        ? DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageProvider == null
                      ? Center(
                          child: Icon(
                            Icons.movie_filter_rounded,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                        )
                      : null,
                ),
                
                // Favorite Badge
                if (userAnime.isFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                
                // Status Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    userAnime.anime.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progress
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${userAnime.progressEpisode}/${userAnime.anime.totalEpisodes ?? '?'} eps',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: userAnime.progressPercentage / 100,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating & Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Anime Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            userAnime.anime.avgRating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      // User Score
                      if (userAnime.score != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.thumb_up,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${userAnime.score}/10',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build ImageProvider safely (handles web cache refs, http URLs, assets, and local files)
  ImageProvider<Object>? _buildImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    // web cached image reference (from admin form modal)
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
}