class ApiConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://rzkrplsmetbbcuebysrg.supabase.co';
  static const String supabaseAnonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6a3JwbHNtZXRiYmN1ZWJ5c3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1OTg5MTQsImV4cCI6MjA3OTE3NDkxNH0.CRuqgwvEnzVblaVa2ArYO2CwIb2sd8GrMbz13r0uht8';

  // Database Tables
  static const String profilesTable = 'profiles';
  static const String animeTable = 'anime';
  static const String userAnimeTable = 'user_anime';

  // Asset Paths
  static const String animeImagesPath = 'assets/images/anime/';
  static const String defaultAnimeImage = '';
  static const String defaultAvatarImage = 'default_avatar.png';

  // Roles
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
  static const String roleBanned = 'banned';

  // Anime Status
  static const List<String> animeStatuses = ['Ongoing', 'Completed', 'Upcoming'];

  // User Anime Status
  static const List<String> userAnimeStatuses = [
    'Watching',
    'Completed',
    'On Hold',
    'Dropped',
    'Plan to Watch'
  ];

  // Genres
  static const List<String> genres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Slice of Life',
    'Sports',
    'Supernatural',
    'Thriller',
  ];
}