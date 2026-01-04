// lib/presentation/anime/list/anime_list_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/use_cases/anime/get_anime_list_use_case.dart';
import '../../../config/providers.dart';

class AnimeListState {
  final List<Anime> animes;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;
  final String? selectedGenre;

  AnimeListState({
    this.animes = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
    this.searchQuery,
    this.selectedGenre,
  });

  AnimeListState copyWith({
    List<Anime>? animes,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    String? selectedGenre,
  }) {
    return AnimeListState(
      animes: animes ?? this.animes,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGenre: selectedGenre ?? this.selectedGenre,
    );
  }
}

class AnimeListController extends StateNotifier<AnimeListState> {
  final GetAnimeListUseCase getAnimeListUseCase;

  AnimeListController(this.getAnimeListUseCase) : super(AnimeListState());

  Future<void> loadAnimes({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        currentPage: 0,
        animes: [],
        hasMore: true,
        error: null,
      );
    } else if (!state.hasMore || state.isLoadingMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    final result = await getAnimeListUseCase(
      page: refresh ? 0 : state.currentPage,
      search: state.searchQuery,
      genre: state.selectedGenre,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (newAnimes) {
        final updatedAnimes = refresh
            ? newAnimes
            : [...state.animes, ...newAnimes];

        state = state.copyWith(
          animes: updatedAnimes,
          isLoading: false,
          isLoadingMore: false,
          currentPage: state.currentPage + 1,
          hasMore: newAnimes.length >= 20,
        );
      },
    );
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query.isEmpty ? null : query);
    loadAnimes(refresh: true);
  }

  void filterByGenre(String? genre) {
    state = state.copyWith(selectedGenre: genre);
    loadAnimes(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      selectedGenre: null,
    );
    loadAnimes(refresh: true);
  }
}

final animeListControllerProvider =
    StateNotifierProvider<AnimeListController, AnimeListState>((ref) {
  final useCase = ref.watch(getAnimeListUseCaseProvider);
  return AnimeListController(useCase);
});