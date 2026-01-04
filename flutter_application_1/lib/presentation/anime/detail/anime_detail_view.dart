// lib/presentation/anime/detail/anime_detail_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/widgets/domain/genre_chip.dart' as widgets;
import '../../../core/widgets/domain/rating_widget.dart' as widgets;
import '../../../core/utils/helpers.dart';
import 'anime_detail_controller.dart';

class AnimeDetailView extends ConsumerWidget {
  final String animeId;

  const AnimeDetailView({
    super.key,
    required this.animeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(animeDetailControllerProvider(animeId));

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
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
                    .read(animeDetailControllerProvider(animeId).notifier)
                    .loadAnimeDetail(animeId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.anime == null) {
      return const Center(child: Text('Anime not found'));
    }

    final anime = state.anime!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image
          Stack(
            children: [
              // Background Image
              Container(
                height: 300,
                width: double.infinity,
                color: AppColors.surfaceLight,
                child: anime.imageUrl != null
                    ? Image.network(
                        anime.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.movie_outlined,
                            size: 80,
                            color: AppColors.textTertiary,
                          );
                        },
                      )
                    : const Icon(
                        Icons.movie_outlined,
                        size: 80,
                        color: AppColors.textTertiary,
                      ),
              ),

              // Gradient Overlay
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.8),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  anime.title,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 8),

                // Rating
                widgets.RatingWidget(rating: anime.rating),
                const SizedBox(height: 16),

                // Info Row
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.tv,
                      label: '${anime.episodes} Episodes',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.calendar_today,
                      label: anime.year?.toString() ?? 'Unknown',
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: anime.status.value == 'Ongoing'
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        anime.status.value,
                        style: AppTextStyles.caption.copyWith(
                          color: anime.status.value == 'Ongoing'
                              ? AppColors.success
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Studio
                if (anime.studio != null) ...[
                  Text(
                    'Studio',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    anime.studio!,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                ],

                // Genres
                Text(
                  'Genres',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: anime.genres
                      .map((genre) => widgets.GenreChip(genre: genre))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Synopsis
                Text(
                  'Synopsis',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  anime.synopsis ?? 'No synopsis available.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Add to List Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Feature coming soon
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add to list feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to My List'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}