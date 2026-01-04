// lib/core/widgets/domain/genre_chip.dart
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class GenreChip extends StatelessWidget {
  final String genre;
  final VoidCallback? onTap;
  final bool isSelected;

  const GenreChip({
    super.key,
    required this.genre,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.divider,
          ),
        ),
        child: Text(
          genre,
          style: AppTextStyles.caption.copyWith(
            color: isSelected
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}