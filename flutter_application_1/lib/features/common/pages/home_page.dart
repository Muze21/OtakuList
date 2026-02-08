import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/features/anime/presentation/pages/seasonal_anime_page.dart';
import 'package:flutter_application_1/features/admin/presentation/pages/admin_dashboard.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
      data: (user) {
        if (user == null) {
          // Not logged in, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Logged in - check role
        if (user.isAdmin) {
          // Admin - show admin dashboard
          return const AdminDashboard();
        } else {
          // Regular user - show seasonal anime page
          return const SeasonalAnimePage();
        }
      },
    );
  }
}
