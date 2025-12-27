// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Anime Tracker';
  static const String appVersion = '1.0.0';
  
  // API
  static const String supabaseUrl = 'https://rzkrplsmetbbcuebysrg.supabase.co';
  static const String supabaseAnonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6a3JwbHNtZXRiYmN1ZWJ5c3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1OTg5MTQsImV4cCI6MjA3OTE3NDkxNH0.CRuqgwvEnzVblaVa2ArYO2CwIb2sd8GrMbz13r0uht8';
  
  // Durations
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}