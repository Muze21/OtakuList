// lib/core/utils/helpers.dart
import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../constants/list_status.dart';

class Helpers {
  /// Get color based on list status
  static Color getStatusColor(ListStatus status) {
    switch (status) {
      case ListStatus.watching:
        return AppColors.watching;
      case ListStatus.completed:
        return AppColors.completed;
      case ListStatus.onHold:
        return AppColors.onHold;
      case ListStatus.dropped:
        return AppColors.dropped;
      case ListStatus.planToWatch:
        return AppColors.planToWatch;
    }
  }

  /// Get icon based on list status
  static IconData getStatusIcon(ListStatus status) {
    switch (status) {
      case ListStatus.watching:
        return Icons.play_circle_outline;
      case ListStatus.completed:
        return Icons.check_circle_outline;
      case ListStatus.onHold:
        return Icons.pause_circle_outline;
      case ListStatus.dropped:
        return Icons.cancel_outlined;
      case ListStatus.planToWatch:
        return Icons.bookmark_border;
    }
  }

  /// Format rating (e.g., 8.5 => "8.5 / 10")
  static String formatRating(double rating) {
    return '${rating.toStringAsFixed(1)} / 10';
  }

  /// Get rating color based on value
  static Color getRatingColor(double rating) {
    if (rating >= 8.0) return AppColors.success;
    if (rating >= 6.0) return AppColors.warning;
    return AppColors.error;
  }

  /// Format episode count (e.g., 5/12 or 12/12)
  static String formatEpisodes(int watched, int total) {
    return '$watched / $total';
  }

  /// Calculate progress percentage
  static double calculateProgress(int watched, int total) {
    if (total == 0) return 0.0;
    return (watched / total).clamp(0.0, 1.0);
  }
}