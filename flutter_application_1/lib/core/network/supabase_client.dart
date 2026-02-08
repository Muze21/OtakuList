import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';

class SupabaseClientService {
  static SupabaseClientService? _instance;
  static SupabaseClientService get instance {
    _instance ??= SupabaseClientService._internal();
    return _instance!;
  }

  SupabaseClientService._internal();

  // Initialize Supabase
  Future<void> initialize() async {
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
    );
  }

  // Getters
  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get auth => Supabase.instance.client.auth;

  // Helper: Get current user
  User? get currentUser => auth.currentUser;
  
  // Helper: Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Helper: Get current user ID
  String? get currentUserId => currentUser?.id;
}

// Global accessor for convenience
final supabase = Supabase.instance.client;