# Router Configuration Guide

## How to Add Admin Page Route

Your app likely uses GoRouter untuk navigation. Tambahkan route ini ke `lib/config/router/app_router.dart`:

```dart
import 'package:flutter_application_1/features/anime/presentation/pages/admin_anime_page.dart';

final appRouter = GoRouter(
  routes: [
    // ... other routes ...
    
    GoRoute(
      path: '/admin/anime',
      name: 'admin-anime',
      builder: (context, state) => const AdminAnimePage(),
    ),
    
    // ... more routes ...
  ],
);
```

## Navigation Methods

### Method 1: Using GoRouter context extension
```dart
// From any widget
context.go('/admin/anime');

// Or with named route
context.goNamed('admin-anime');
```

### Method 2: From a button
```dart
ElevatedButton(
  onPressed: () => context.go('/admin/anime'),
  child: const Text('Admin Panel'),
)
```

### Method 3: From main app menu
Add menu option dalam AppBar atau drawer:

```dart
PopupMenuButton<String>(
  itemBuilder: (BuildContext context) => [
    const PopupMenuItem<String>(
      value: 'anime',
      child: Text('Manage Anime'),
    ),
  ],
  onSelected: (value) {
    if (value == 'anime') {
      context.go('/admin/anime');
    }
  },
)
```

## Access Control

Tambahkan authentication check supaya hanya admin yang bisa access:

### Option 1: GuardRoute
```dart
GoRoute(
  path: '/admin/anime',
  name: 'admin-anime',
  builder: (context, state) => const AdminAnimePage(),
  redirect: (context, state) async {
    // Check if user is admin
    final authService = AuthService.instance;
    final user = await authService.getCurrentUser();
    
    if (user == null || !user.isAdmin) {
      return '/'; // Redirect to home if not admin
    }
    return null; // Allow access
  },
)
```

### Option 2: Wrapper Widget
```dart
GoRoute(
  path: '/admin/anime',
  name: 'admin-anime',
  builder: (context, state) => const AdminAccessWrapper(
    child: AdminAnimePage(),
  ),
)

// Create wrapper widget
class AdminAccessWrapper extends ConsumerWidget {
  final Widget child;
  const AdminAccessWrapper({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    
    if (!user.isAdmin) {
      return const UnauthorizedPage();
    }
    
    return child;
  }
}
```

## Example: Complete Router Setup

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/anime/presentation/pages/admin_anime_page.dart';
import 'package:flutter_application_1/features/anime/presentation/pages/seasonal_anime_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/register_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const SeasonalAnimePage(),
    ),
    GoRoute(
      path: '/admin/anime',
      name: 'admin-anime',
      builder: (context, state) => const AdminAnimePage(),
      redirect: (context, state) async {
        // Add admin check here if needed
        return null;
      },
    ),
  ],
);
```

## Next Steps

1. Update your `app_router.dart` file with admin route
2. Test navigation: open admin page in browser/app
3. Verify you can see anime list
4. Try adding/editing/deleting anime
5. Check Supabase to confirm data changes
