import 'package:flutter_application_1/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';

class AnimeRepository {
  final AnimeRemoteDatasource _remoteDatasource;

  AnimeRepository(this._remoteDatasource);

  /// Get all anime dengan filters
  Future<List<AnimeModel>> getAllAnime({
    String? status,
    String? searchQuery,
    String? sortBy,
  }) async {
    return await _remoteDatasource.getAllAnime(
      status: status,
      searchQuery: searchQuery,
      sortBy: sortBy,
    );
  }

  /// Get anime by ID
  Future<AnimeModel> getAnimeById(String animeId) async {
    return await _remoteDatasource.getAnimeById(animeId);
  }

  /// Get anime by status
  Future<List<AnimeModel>> getAnimeByStatus(String status) async {
    return await _remoteDatasource.getAnimeByStatus(status);
  }

  /// Search anime
  Future<List<AnimeModel>> searchAnime(String query) async {
    return await _remoteDatasource.searchAnime(query);
  }

  /// Create anime (Admin)
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
    return await _remoteDatasource.createAnime(
      title: title,
      synopsis: synopsis,
      episodes: episodes,
      genres: genres,
      status: status,
      year: year,
      studio: studio,
      imageFileName: imageFileName,
      rating: rating,
    );
  }

  /// Update anime
  Future<AnimeModel> updateAnime(AnimeModel anime) async {
    return await _remoteDatasource.updateAnime(anime);
  }

  /// Delete anime
  Future<void> deleteAnime(String animeId) async {
    return await _remoteDatasource.deleteAnime(animeId);
  }
}
