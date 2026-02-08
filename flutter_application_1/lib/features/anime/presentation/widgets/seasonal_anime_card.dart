import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/features/anime/data/models/season_model.dart';
import 'package:flutter_application_1/features/anime/presentation/widgets/anime_form_modal.dart' as animeFormModal;
import 'dart:io';

class SeasonalAnimeCard extends StatelessWidget {
  final AnimeCard anime;
  final VoidCallback? onTap;
  final VoidCallback? onAddToList;

  const SeasonalAnimeCard({
    super.key,
    required this.anime,
    this.onTap,
    this.onAddToList,
  });

  Color _getStatusColor() {
    switch (anime.status) {
      case 'ongoing':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      case 'upcoming':
        return AppColors.warning;
      default:
        return AppColors.textHint;
    }
  }

  String _getStatusLabel() {
    switch (anime.status) {
      case 'ongoing':
        return 'AIRING';
      case 'completed':
        return 'FINISHED';
      case 'upcoming':
        return 'UPCOMING';
      default:
        return anime.status.toUpperCase();
    }
  }

  ImageProvider<Object>? _buildImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('web_image:')) {
      final filename = imagePath.replaceFirst('web_image:', '');
      if (animeFormModal.webImageCache.containsKey(filename)) return MemoryImage(animeFormModal.webImageCache[filename]!);
      return null;
    }
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    if (imagePath.startsWith('assets/')) return AssetImage(imagePath);
    return FileImage(File(imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
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
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: AppColors.surfaceLight,
                    image: _buildImageProvider(anime.coverImageUrl) != null
                        ? DecorationImage(
                            image: _buildImageProvider(anime.coverImageUrl)!,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _buildImageProvider(anime.coverImageUrl) == null
                      ? Center(
                          child: Icon(
                            Icons.movie_filter_rounded,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                        )
                      : null,
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                
                // Type Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      anime.type,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      anime.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Metadata
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildMetaChip(
                          Icons.calendar_today,
                          anime.releaseDate,
                        ),
                        _buildMetaChip(
                          Icons.tv,
                          '${anime.episodeCount} eps',
                        ),
                        _buildMetaChip(
                          Icons.access_time,
                          '${anime.durationMinutes}m',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Genres
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: anime.genres.take(3).map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Synopsis
                    Expanded(
                      child: Text(
                        anime.synopsis,
                        style: AppTextStyles.caption.copyWith(
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Studio
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 12,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            anime.studio,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Rating & Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  anime.avgRating.toStringAsFixed(1),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${anime.totalRatings} users',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        
                        // Add Button
                        ElevatedButton.icon(
                          onPressed: onAddToList,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}