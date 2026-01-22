import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';

class AnimeStatsCard extends StatelessWidget {
  final int totalAnime;
  final int watching;
  final int completed;
  final int planned;
  final int dropped;

  const AnimeStatsCard({
    super.key,
    required this.totalAnime,
    required this.watching,
    required this.completed,
    required this.planned,
    required this.dropped,
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
            'Your Stats',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                'Total',
                totalAnime.toString(),
                AppColors.primary,
                Icons.movie_filter_rounded,
              ),
              _buildStatItem(
                'Watching',
                watching.toString(),
                AppColors.primary,
                Icons.play_circle_outline,
              ),
              _buildStatItem(
                'Completed',
                completed.toString(),
                AppColors.success,
                Icons.check_circle_outline,
              ),
              _buildStatItem(
                'Planned',
                planned.toString(),
                AppColors.warning,
                Icons.schedule_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            fontSize: 20,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}