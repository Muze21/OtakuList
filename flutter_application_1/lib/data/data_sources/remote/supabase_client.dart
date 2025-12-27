// lib/data/data_sources/remote/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  static SupabaseClient get instance => Supabase.instance.client;
}