// lib/domain/entities/review.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';

part 'review.freezed.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    required String animeId,
    required String content,
    required double rating,
    Profile? user, // Relasi ke user profile
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Review;
}