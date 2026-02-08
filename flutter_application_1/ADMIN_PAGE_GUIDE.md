# Admin Page Guide

## Overview
Admin halaman untuk manage anime database. Admin bisa menambah, mengedit, dan menghapus anime dari Supabase.

## Files Created

### 1. **admin_anime_page.dart**
```
lib/features/anime/presentation/pages/admin_anime_page.dart
```
- **Purpose**: Main admin page UI untuk list semua anime
- **Features**:
  - List anime dalam format table/cards
  - Search anime by title atau synopsis
  - Edit button untuk setiap anime
  - Delete button dengan confirmation dialog
  - "Add Anime" FAB (Floating Action Button) untuk input anime baru
  - Responsive design (desktop & mobile)
  - Real-time error handling dengan snackbars

- **Key Components**:
  - `AdminAnimePage`: ConsumerStatefulWidget untuk access Riverpod providers
  - `_AdminAnimePageState`: Manages search query state
  - `_AnimeListTile`: Custom widget untuk setiap anime row
  - Status color indicators (green=Ongoing, blue=Completed, orange=Upcoming)

### 2. **anime_form_modal.dart**
```
lib/features/anime/presentation/widgets/anime_form_modal.dart
```
- **Purpose**: Modal form untuk input/edit anime data
- **Features**:
  - Input fields untuk: Title, Year, Episodes, Rating, Status, Studio, Genres, Synopsis
  - Form validation (required fields: title, year, episodes, rating, status)
  - Dropdown untuk Status (Ongoing, Completed, Upcoming)
  - Genres: comma-separated input (e.g., "Action, Drama, Fantasy")
  - Submit button dengan loading state
  - Error handling dengan snackbar
  - Support untuk create new anime atau edit existing anime

- **Form Fields**:
  ```
  Title (required) *
  Year (required) * | Episodes (required) * | Rating (required) *
  Status (required) * [Dropdown: Ongoing, Completed, Upcoming]
  Studio (optional)
  Genres (optional) - comma separated
  Synopsis (optional) - multiline text
  ```

### 3. **Updated Repository & Datasource**
Added three new methods untuk handle anime management:

#### anime_remote_datasource.dart
```dart
// Update existing anime
Future<AnimeModel> updateAnime(AnimeModel anime)

// Delete anime
Future<void> deleteAnime(String animeId)
```

#### anime_repository_impl.dart
```dart
// Update anime
Future<AnimeModel> updateAnime(AnimeModel anime)

// Delete anime
Future<void> deleteAnime(String animeId)
```

## How to Use

### Access Admin Page
```dart
// Add this route to your router (lib/config/router/app_router.dart)
GoRoute(
  path: '/admin/anime',
  builder: (context, state) => const AdminAnimePage(),
)

// Or navigate via:
context.go('/admin/anime');
```

### Create New Anime
1. Click "Add Anime" FAB button
2. Fill form fields (red asterisk = required)
3. Click "Add Anime" button
4. Success message appears + list auto-refreshes

### Edit Anime
1. Click "Edit" (pencil icon) on anime card
2. Form loads with existing data
3. Modify fields as needed
4. Click "Update Anime" button
5. Success message + list auto-refreshes

### Delete Anime
1. Click "Delete" (trash icon) on anime card
2. Confirm delete in dialog
3. Anime removed from database
4. List auto-refreshes

## Database Integration

### Supabase Table: `anime`
Required fields for database operations:
```sql
id (UUID) - Primary key
title (TEXT) - Anime title
synopsis (TEXT) - Plot description
image_file_name (TEXT) - Image filename
episodes (INTEGER) - Number of episodes
rating (NUMERIC) - Avg rating (0-10)
genres (TEXT[] or JSON) - Array of genre strings
status (TEXT) - 'Ongoing', 'Completed', 'Upcoming'
year (INTEGER) - Release year
studio (TEXT) - Production studio
created_at (TIMESTAMP) - Auto-set by database
updated_at (TIMESTAMP) - Auto-updated on edit
```

## State Management

### Riverpod Providers Used
- `allAnimeProvider(AnimeFilters)` - FutureProvider for anime list
- `animeRepositoryProvider` - Provides AnimeRepository instance
- `animeRemoteDatasourceProvider` - Provides datasource

### Cache Invalidation
When anime is modified (create/update/delete), cache is invalidated:
```dart
ref.invalidate(allAnimeProvider);
```
This triggers automatic refetch from Supabase with fresh data.

## Error Handling

All operations have comprehensive error handling:
- Form validation errors → Red snackbar
- Database errors → Error snackbar with error message
- Network errors → Caught and displayed
- User feedback via SnackBars and dialogs

## Security Notes

⚠️ **Important**: These operations should only be accessible to admin users!

Add authentication check in admin page:
```dart
@override
Widget build(BuildContext context) {
  final user = ref.watch(authProvider);
  
  // Only show admin page if user.isAdmin == true
  if (!user.isAdmin) {
    return const UnauthorizedPage();
  }
  
  // ... rest of build
}
```

## Future Enhancements

1. **Bulk Operations**
   - Bulk delete selected anime
   - Bulk update status

2. **Image Upload**
   - Upload anime poster image
   - Store in Supabase Storage

3. **Pagination**
   - For large anime lists (>1000)

4. **Filtering**
   - Filter by status before operations
   - Filter by year range

5. **Sorting**
   - Custom sort options in admin view

6. **Anime Details**
   - More detailed fields (MAL score, producers, etc.)

7. **Activity Log**
   - Track who created/edited/deleted what and when

## Testing Checklist

- [ ] Can load admin page without errors
- [ ] Search works and filters anime list
- [ ] "Add Anime" FAB opens form modal
- [ ] Form validation works (try submitting empty)
- [ ] Can create new anime successfully
- [ ] New anime appears in list immediately
- [ ] Can click Edit and modify anime
- [ ] Updated anime reflected in list
- [ ] Can delete anime with confirmation
- [ ] Deleted anime removed from list
- [ ] Error handling works (bad network, invalid data)
- [ ] Page responsive on mobile & desktop
- [ ] Pagination works if >50 anime
