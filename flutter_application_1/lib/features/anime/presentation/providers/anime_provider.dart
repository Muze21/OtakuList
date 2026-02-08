import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:flutter_application_1/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';

// ========== PROVIDERS ==========

/// Anime Remote Datasource Provider
final animeRemoteDatasourceProvider = Provider<AnimeRemoteDatasource>((ref) {
  return AnimeRemoteDatasource();
});

/// Anime Repository Provider
final animeRepositoryProvider = Provider<AnimeRepository>((ref) {
  final datasource = ref.read(animeRemoteDatasourceProvider);
  return AnimeRepository(datasource);
});

/// Get all anime provider dengan state management
final allAnimeProvider = FutureProvider.family<List<AnimeModel>, AnimeFilters>(
  (ref, filters) async {
    final repository = ref.read(animeRepositoryProvider);
    return await repository.getAllAnime(
      status: filters.status,
      searchQuery: filters.searchQuery,
      sortBy: filters.sortBy,
    );
  },
);

/// Get anime by ID
final animeByIdProvider = FutureProvider.family<AnimeModel, String>(
  (ref, animeId) async {
    final repository = ref.read(animeRepositoryProvider);
    return await repository.getAnimeById(animeId);
  },
);

/// Get anime by status
final animeByStatusProvider = FutureProvider.family<List<AnimeModel>, String>(
  (ref, status) async {
    final repository = ref.read(animeRepositoryProvider);
    return await repository.getAnimeByStatus(status);
  },
);

/// Search anime provider
final searchAnimeProvider = FutureProvider.family<List<AnimeModel>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    final repository = ref.read(animeRepositoryProvider);
    return await repository.searchAnime(query);
  },
);

// ========== STATE NOTIFIERS ==========

/// Notifier untuk manage anime filters
class AnimeFiltersNotifier extends StateNotifier<AnimeFilters> {
  AnimeFiltersNotifier()
      : super(
          AnimeFilters(
            status: 'All',
            searchQuery: '',
            sortBy: 'rating',
          ),
        );

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void resetFilters() {
    state = AnimeFilters(
      status: 'All',
      searchQuery: '',
      sortBy: 'rating',
    );
  }
}

/// Anime filters state provider
final animeFiltersProvider = StateNotifierProvider<AnimeFiltersNotifier, AnimeFilters>(
  (ref) => AnimeFiltersNotifier(),
);

/// Combined provider yang auto-refetch ketika filters berubah
final filteredAnimeProvider = FutureProvider<List<AnimeModel>>((ref) async {
  final filters = ref.watch(animeFiltersProvider);
  return await ref.watch(allAnimeProvider(filters).future);
});

// ========== MODELS ==========

class AnimeFilters {
  final String status;
  final String searchQuery;
  final String sortBy;

  AnimeFilters({
    required this.status,
    required this.searchQuery,
    required this.sortBy,
  });

  AnimeFilters copyWith({
    String? status,
    String? searchQuery,
    String? sortBy,
  }) {
    return AnimeFilters(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeFilters &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          searchQuery == other.searchQuery &&
          sortBy == other.sortBy;

  @override
  int get hashCode => status.hashCode ^ searchQuery.hashCode ^ sortBy.hashCode;
}
