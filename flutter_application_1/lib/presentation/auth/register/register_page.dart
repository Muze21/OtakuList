// lib/presentation/auth/register/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/extensions.dart';
import 'register_controller.dart';
import 'register_view.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to state changes
    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.error != null) {
        context.showSnackBar(next.error!, isError: true);
      }
      if (next.isSuccess) {
        context.showSnackBar('Account created successfully!');
        // Navigate to home on success
        context.go('/home');
      }
    });

    return const Scaffold(
      body: SafeArea(
        child: RegisterView(),
      ),
    );
  }
}