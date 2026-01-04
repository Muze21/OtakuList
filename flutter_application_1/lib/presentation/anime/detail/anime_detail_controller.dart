// lib/presentation/anime/detail/anime_detail_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/use_cases/anime/get_anime_detail_use_case.dart';
import '../../../config/providers.dart';

class AnimeDetailState {
  final Anime? anime;
  final bool isLoading;
  final String? error;

  AnimeDetailState({
    this.anime,
    this.isLoading = false,
    this.error,
  });

  AnimeDetailState copyWith({
    Anime? anime,
    bool? isLoading,
    String? error,
  }) {
    return AnimeDetailState(
      anime: anime ?? this.anime,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AnimeDetailController extends StateNotifier<AnimeDetailState> {
  final GetAnimeDetailUseCase getAnimeDetailUseCase;

  AnimeDetailController(this.getAnimeDetailUseCase)
      : super(AnimeDetailState());

  Future<void> loadAnimeDetail(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getAnimeDetailUseCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (anime) {
        state = state.copyWith(
          anime: anime,
          isLoading: false,
        );
      },
    );
  }
}

// Family provider untuk different anime IDs
final animeDetailControllerProvider = StateNotifierProvider.family<
    AnimeDetailController, AnimeDetailState, String>((ref, animeId) {
  final useCase = ref.watch(getAnimeDetailUseCaseProvider);
  return AnimeDetailController(useCase);
});