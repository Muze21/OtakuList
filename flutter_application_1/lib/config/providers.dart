// lib/config/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/data_sources/remote/auth_remote_data_source.dart';
import '../data/repositories_impl/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/auth/login_use_case.dart';
import '../domain/use_cases/auth/register_use_case.dart';
import '../domain/use_cases/anime/get_anime_list_use_case.dart';
import '../domain/use_cases/anime/get_anime_detail_use_case.dart';
import '../data/data_sources/remote/anime_remote_data_source.dart';
import '../data/repositories_impl/anime_repository_impl.dart';
import '../domain/repositories/anime_repository.dart';

// Supabase Client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

final animeRemoteDataSourceProvider = Provider<AnimeRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AnimeRemoteDataSourceImpl(client);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final animeRepositoryProvider = Provider<AnimeRepository>((ref) {
  final remoteDataSource = ref.watch(animeRemoteDataSourceProvider);
  return AnimeRepositoryImpl(remoteDataSource);
});

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final getAnimeListUseCaseProvider = Provider<GetAnimeListUseCase>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetAnimeListUseCase(repository);
});

final getAnimeDetailUseCaseProvider = Provider<GetAnimeDetailUseCase>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetAnimeDetailUseCase(repository);
});

// Auth State Stream
final authStateProvider = StreamProvider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});