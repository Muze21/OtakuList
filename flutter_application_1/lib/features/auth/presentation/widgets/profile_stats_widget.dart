import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

class ProfileStatsWidget extends StatelessWidget {
  final UserStats stats;

  const ProfileStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Statistics',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 20),
          
          // Main Stats
          Row(
            children: [
              Expanded(
                child: _buildMainStatCard(
                  'Total Anime',
                  stats.totalAnime.toString(),
                  Icons.movie_filter_rounded,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMainStatCard(
                  'Episodes',
                  stats.totalEpisodesWatched.toString(),
                  Icons.play_circle_outline,
                  AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMainStatCard(
                  'Avg Rating',
                  stats.averageRating.toStringAsFixed(1),
                  Icons.star,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Breakdown Stats
          _buildBreakdownStat(
            'Watching',
            stats.totalWatching,
            stats.totalAnime,
            AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildBreakdownStat(
            'Completed',
            stats.totalCompleted,
            stats.totalAnime,
            AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildBreakdownStat(
            'Plan to Watch',
            stats.totalPlanned,
            stats.totalAnime,
            AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildBreakdownStat(
            'Dropped',
            stats.totalDropped,
            stats.totalAnime,
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              color: color,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownStat(
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$count (${percentage.toStringAsFixed(0)}%)',
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}