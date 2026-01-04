// lib/core/widgets/domain/rating_widget.dart
import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 20,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final fullStars = rating ~/ 2;
    final hasHalfStar = (rating % 2) >= 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        ...List.generate(5, (index) {
          if (index < fullStars) {
            return Icon(
              Icons.star,
              size: size,
              color: AppColors.warning,
            );
          } else if (index == fullStars && hasHalfStar) {
            return Icon(
              Icons.star_half,
              size: size,
              color: AppColors.warning,
            );
          } else {
            return Icon(
              Icons.star_border,
              size: size,
              color: AppColors.textTertiary,
            );
          }
        }),
        
        // Rating value
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}