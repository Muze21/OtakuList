import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';

class AnimeRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all anime (dengan optional filters)
  Future<List<AnimeModel>> getAllAnime({
    String? status,
    String? searchQuery,
    String? sortBy = 'rating',
  }) async {
    try {
      dynamic query = _supabase
          .from(ApiConstants.animeTable)
          .select();

      // Filter by status jika ada
      if (status != null && status != 'All') {
        query = query.eq('status', status);
      }

      // Filter by search jika ada
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'title.ilike.%$searchQuery%,synopsis.ilike.%$searchQuery%',
        );
      }

      // Sort
      switch (sortBy) {
        case 'rating':
          query = query.order('rating', ascending: false);
          break;
        case 'popularity':
          query = query.order('created_at', ascending: false);
          break;
        case 'title':
          query = query.order('title', ascending: true);
          break;
        default:
          query = query.order('rating', ascending: false);
      }

      final response = await query;
      
      return (response as List)
          .map((json) => AnimeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('[ANIME ERROR] Failed to get all anime: $e');
    }
  }

  /// Get anime by ID
  Future<AnimeModel> getAnimeById(String animeId) async {
    try {
      final response = await _supabase
          .from(ApiConstants.animeTable)
          .select()
          .eq('id', animeId)
          .single();

      return AnimeModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch anime: $e');
    }
  }

  /// Get anime by status
  Future<List<AnimeModel>> getAnimeByStatus(String status) async {
    try {
      final response = await _supabase
          .from(ApiConstants.animeTable)
          .select()
          .eq('status', status)
          .order('rating', ascending: false);

      return (response as List)
          .map((json) => AnimeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch anime by status: $e');
    }
  }

  /// Search anime
  Future<List<AnimeModel>> searchAnime(String query) async {
    try {
      final response = await _supabase
          .from(ApiConstants.animeTable)
          .select()
          .or('title.ilike.%$query%,synopsis.ilike.%$query%,genres.cs.{$query}')
          .order('rating', ascending: false);

      return (response as List)
          .map((json) => AnimeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  /// Insert anime (Admin only)
  Future<AnimeModel> createAnime({
    required String title,
    required String synopsis,
    required int episodes,
    required List<String> genres,
    required String status,
    required int year,
    required String studio,
    String imageFileName = '',
    double rating = 0.0,
  }) async {
    try {
      final response = await _supabase
          .from(ApiConstants.animeTable)
          .insert({
            'title': title,
            'synopsis': synopsis,
            'image_file_name': imageFileName,
            'episodes': episodes,
            'rating': rating,
            'genres': genres,
            'status': status,
            'year': year,
            'studio': studio,
          })
          .select()
          .single();

      return AnimeModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create anime: $e');
    }
  }

  /// Update existing anime
  Future<AnimeModel> updateAnime(AnimeModel anime) async {
    try {
      final response = await _supabase
          .from(ApiConstants.animeTable)
          .update({
              'title': anime.title,
              'synopsis': anime.synopsis,
              'image_file_name': anime.imageFileName,
              'genres': anime.genres,
              'year': anime.year,
              'episodes': anime.episodes,
              'rating': anime.rating,
              'status': anime.status,
              'studio': anime.studio,
              'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', anime.id)
          .select()
          .single();

      return AnimeModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update anime: $e');
    }
  }

  /// Delete anime
  Future<void> deleteAnime(String animeId) async {
    try {
      await _supabase
          .from(ApiConstants.animeTable)
          .delete()
          .eq('id', animeId);
    } catch (e) {
      throw Exception('Failed to delete anime: $e');
    }
  }
}
