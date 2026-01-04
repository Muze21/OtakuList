// lib/data/data_sources/remote/anime_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/anime_model.dart';

abstract class AnimeRemoteDataSource {
  Future<List<AnimeModel>> getAnimeList({
    int page = 0,
    int limit = 20,
    String? search,
    String? genre,
  });
  
  Future<AnimeModel> getAnimeById(String id);
}

class AnimeRemoteDataSourceImpl implements AnimeRemoteDataSource {
  final SupabaseClient client;

  AnimeRemoteDataSourceImpl(this.client);

  @override
  Future<List<AnimeModel>> getAnimeList({
    int page = 0,
    int limit = 20,
    String? search,
    String? genre,
  }) async {
    try {
      // Start with base query
      var query = client
          .from('anime')
          .select();

      // Apply search filter
      if (search != null && search.isNotEmpty) {
        query = query.ilike('title', '%$search%');
      }

      // Apply genre filter
      if (genre != null && genre.isNotEmpty) {
        query = query.contains('genres', [genre]);
      }

      // Apply ordering and pagination
      final response = await query
          .order('rating', ascending: false)
          .range(page * limit, (page * limit) + limit - 1);
      
      return (response as List)
          .map((json) => AnimeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AnimeModel> getAnimeById(String id) async {
    try {
      final response = await client
          .from('anime')
          .select()
          .eq('id', id)
          .single();

      return AnimeModel.fromJson(response);
    } catch (e) {
      throw NotFoundException('Anime not found');
    }
  }
}