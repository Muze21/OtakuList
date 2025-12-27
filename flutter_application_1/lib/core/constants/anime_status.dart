// lib/core/constants/anime_status.dart
enum AnimeStatus {
  ongoing('Ongoing'),
  completed('Completed'),
  upcoming('Upcoming');

  final String value;
  const AnimeStatus(this.value);

  static AnimeStatus fromString(String value) {
    return AnimeStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AnimeStatus.ongoing,
    );
  }
}