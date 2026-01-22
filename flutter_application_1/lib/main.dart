import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/profile_page.dart';
//import 'package:flutter_application_1/features/anime/presentation/pages/seasonal_anime_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // home: const SeasonalAnimePage(), // Test Dashboard
      // home: const LoginPageResponsive(),  Uncomment for login
      home: const ProfilePage(),
    );
  }
}