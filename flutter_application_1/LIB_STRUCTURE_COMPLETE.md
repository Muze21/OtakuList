# 📁 Complete LIB Structure & Codebase Map

## 🎯 Quick Overview
This is a **Flutter Anime Tracking App** with Supabase backend. The app allows users to track anime and admins to add/edit anime. **Recent focus**: Fixing image upload for admin Add Anime feature.

---

## 📂 Full Directory Structure with File Descriptions

```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── constants/
│   │   ├── api_constants.dart          # Supabase URL, key, API endpoints
│   │   ├── app_colors.dart             # Color constants (primary, secondary, etc)
│   │   ├── app_sizes.dart              # Padding, spacing constants
│   │   └── app_text_styles.dart        # TextStyle constants
│   ├── network/
│   │   └── supabase_client.dart         # Supabase initialization & singleton
│   ├── theme/
│   │   └── app_theme.dart              # Dark theme definition
│   └── utils/
│       └── responsive_helper.dart      # Screen size detection helper
│
├── features/
│   ├── auth/                           # Authentication feature
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── anime_entity.dart   # (Duplicate - see anime/)
│   │   │   │   └── user_anime_entity.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart # Auth repository interface
│   │   │
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart  # Supabase auth calls
│   │   │   ├── models/
│   │   │   │   └── user_profile_model.dart      # User profile model
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart    # Auth repo implementation
│   │   │
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── login_page_responsive.dart
│   │       │   ├── register_page.dart
│   │       │   ├── register_page_responsive.dart
│   │       │   └── profile_page.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart           # Riverpod auth state
│   │       └── widgets/
│   │           ├── custom_text_field.dart
│   │           ├── custom_button.dart
│   │           └── profile_stats_widget.dart
│   │
│   ├── anime/                          # Anime feature (MAIN FOCUS)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── anime_entity.dart              # Core anime data class
│   │   │   │   └── user_anime_entity.dart         # User's anime list entry
│   │   │   └── repositories/
│   │   │       └── anime_repository.dart          # Anime repo interface
│   │   │
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── anime_remote_datasource.dart   # ⭐ Supabase CRUD calls
│   │   │   ├── models/
│   │   │   │   ├── anime_model.dart               # ⭐ Maps DB JSON → Entity
│   │   │   │   ├── user_anime_model.dart
│   │   │   │   └── season_model.dart
│   │   │   └── repositories/
│   │   │       └── anime_repository_impl.dart     # ⭐ Anime repo implementation
│   │   │
│   │   ├── datasources/
│   │   │   └── anime_remote_datasource.dart       # (Duplicate?)
│   │   │
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── admin_anime_page.dart          # ⭐ Admin panel: add/edit anime
│   │       │   ├── my_anime_list_page.dart        # User's anime list
│   │       │   └── seasonal_anime_page.dart       # Browse seasonal anime
│   │       ├── providers/
│   │       │   └── anime_provider.dart            # ⭐ Riverpod state (CRUD)
│   │       └── widgets/
│   │           ├── anime_card.dart                # ⭐ Display anime with image
│   │           ├── anime_form_modal.dart          # ⭐ Form to add/edit anime + image upload
│   │           ├── seasonal_anime_card.dart
│   │           └── anime_stats_card.dart
│   │
│   ├── common/
│   │   └── pages/
│   │       └── home_page.dart                     # Home page routing
│   │
│   └── admin/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── admin_datasource.dart          # Admin operations (Supabase)
│       │   └── repositories/
│       │       └── admin_repository.dart          # Admin repo interface
│       └── presentation/
│           ├── pages/
│           │   ├── admin_dashboard.dart           # Admin dashboard home
│           │   └── admin_users_page.dart          # User management
│           └── providers/
│               └── admin_provider.dart            # Admin state (Riverpod)
```

---

## 🔄 Data Flow: Image Upload (The Problem We're Fixing)

### Current Flow:
```
1. User clicks "Add Anime" → admin_anime_page.dart
   ↓
2. Form opens → anime_form_modal.dart
   - User fills: title, synopsis, etc.
   - User picks image → _pickImage()
   ↓
3. Image stored via _saveImageToAssets():
   
   ✅ WEB:
      - Bytes saved to imageCache (Map<String, Uint8List>)
      - Returns: "web_image:filename"
      - Attempts Supabase Storage upload → returns public URL if success
      
   ✅ MOBILE:
      - File saved to: documents/anime_images/
      - Attempts Supabase Storage upload → returns public URL if success
      - Fallback: returns absolute file path
   ↓
4. Submit form → anime_repository_impl.dart
   - Calls: anime_remote_datasource.createAnime()
   - Sends: { title, synopsis, image_file_name: "...", ... }
   ↓
5. Supabase saves anime record with image_file_name field
   ↓
6. Display anime → anime_card.dart
   - Gets: userAnime.anime.coverImageUrl (from AnimeEntity getter)
   - Calls: _buildImageProvider(coverImageUrl)
   - Logic:
     • If "web_image:" → lookup imageCache, use MemoryImage
     • If "http://" → use NetworkImage (Supabase public URL)
     • If "assets/" → use AssetImage
     • Otherwise → use FileImage (local path)
```

### Issue (Gambar Masuk DB tapi Tidak Muncul di UI):
```
Problem: Image stored in Supabase Storage
         BUT UI shows NO image

Possible Causes:
1. ❌ AnimeCard not resolving correct image path
2. ❌ _buildImageProvider() not handling URL correctly
3. ❌ coverImageUrl returning wrong format
4. ❌ Supabase public URL not accessible (CORS/policy)
5. ❌ imageCache empty (web session lost)
```

---

## 🔑 Key Classes & Their Relationships

### Entity Layer (Domain)
```dart
// lib/features/anime/domain/entities/anime_entity.dart
class AnimeEntity {
  final String id;
  final String title;
  final String imageFileName;           // ← Image reference (DB)
  final int episodes;
  final double rating;
  final List<String> genres;
  final String status;
  
  String get coverImageUrl {             // ← Computed getter for UI
    // Returns: http URL, web_image:xx, file path, or asset path
  }
}
```

### Model Layer (Data)
```dart
// lib/features/anime/data/models/anime_model.dart
class AnimeModel extends AnimeEntity {
  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      imageFileName: json['image_file_name'] as String? ?? 'default_anime.jpg',
      // ... other fields
    );
  }
  
  Map<String, dynamic> toCreateJson() {
    return {
      'image_file_name': imageFileName,  // ← Sent to Supabase
      // ... other fields
    };
  }
}
```

### User Anime (User's List Entry)
```dart
// lib/features/anime/data/models/user_anime_model.dart
class UserAnimeList {
  final AnimeModel anime;               // ← Contains image info
  final String listStatus;              // watching, completed, planned, dropped
  final int progressEpisode;
  final int? score;
  final bool isFavorite;
}
```

---

## 🖼️ Image Upload Flow - Code Details

### 1️⃣ Image Pick & Save (anime_form_modal.dart)
```dart
Map<String, Uint8List> imageCache = {}; // ← Web session cache (SHARED)

Future<void> _pickImage() async {
  // Web: file_picker returns bytes
  // Mobile: image_picker returns File/XFile
  // Result stored via _saveImageToAssets()
}

Future<String> _saveImageToAssets(
  Uint8List? webBytes, 
  File? mobileFile
) async {
  // ✅ WEB: Save to imageCache, attempt Supabase upload, return web_image:xx or http URL
  // ✅ MOBILE: Save to documents/anime_images, attempt Supabase upload, return URL or file path
}

Future<void> _submitForm() async {
  final imageRef = await _saveImageToAssets(webBytes, mobileFile);
  // imageRef = "web_image:Screenshot..." or "http://..." or "/path/to/file"
  
  anime = anime.copyWith(imageFileName: imageRef);
  await repository.createAnime(anime); // Sends imageRef to DB
}
```

### 2️⃣ Display Image (anime_card.dart)
```dart
String? resolvedImagePath = userAnime.anime.coverImageUrl; 
// From AnimeEntity getter

ImageProvider? provider = _buildImageProvider(resolvedImagePath);

ImageProvider<Object>? _buildImageProvider(String? imagePath) {
  if (imagePath.startsWith('web_image:')) {
    final filename = imagePath.replaceFirst('web_image:', '');
    return MemoryImage(imageCache[filename]!); // ← Lookup cache
  }
  if (imagePath.startsWith('http')) {
    return NetworkImage(imagePath); // ← Supabase public URL
  }
  if (imagePath.startsWith('assets/')) {
    return AssetImage(imagePath);
  }
  return FileImage(File(imagePath)); // ← Local path
}
```

---

## 🛠️ Recent Changes I Made

### Change 1: anime_form_modal.dart
**Added**:
- `imageCache` Map to store web bytes in-memory
- Supabase upload attempt in `_saveImageToAssets()`
- Debug prints in `_pickImage()` and `_submitForm()`

**Changed**:
- `_saveImageToAssets()` now handles web + mobile differently
- Returns: public URL (if upload succeeded) OR `web_image:filename` OR local path

### Change 2: anime_card.dart
**Added**:
- `_resolveImagePath()` helper to check both `coverImageUrl` and `imageFileName`
- Import: `import 'anime_form_modal.dart' show imageCache;`

**Changed**:
- `_buildImageProvider()` now recognizes `web_image:` format and looks up cache

### Change 3: anime_entity.dart
**Changed**:
- `coverImageUrl` getter now recognizes:
  - HTTP URLs (Supabase public)
  - `web_image:` references
  - Absolute file paths
  - Asset paths

### Change 4: anime_remote_datasource.dart
**Changed**:
- `updateAnime()` now includes `'image_file_name': anime.imageFileName`

---

## 📋 Supabase Database Schema

```sql
-- anime table
CREATE TABLE anime (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  synopsis TEXT,
  image_file_name TEXT DEFAULT 'default_anime.jpg',  -- ← Image reference
  episodes INTEGER NOT NULL,
  rating FLOAT,
  genres TEXT[] or JSONB,
  status TEXT,
  year INTEGER,
  studio TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);

-- Storage bucket: "anime"
-- Path: anime/{uploaded_filename}
```

---

## 🔌 Riverpod Providers

### anime_provider.dart
```dart
// Get anime list
final animeListProvider = FutureProvider<List<AnimeModel>>(/* ... */);

// Watch anime details
final animeDetailProvider = FutureProvider.family<AnimeModel, String>(/* ... */);

// Create/update anime
final createAnimeProvider = FutureProvider.family<AnimeModel, AnimeModel>(/* ... */);
```

---

## 🎨 Constants & Helpers

### api_constants.dart
```dart
class ApiConstants {
  static const String supabaseUrl = '...';
  static const String supabaseAnonKey = '...';
  static const String animeBucket = 'anime';
}
```

### app_colors.dart
```dart
class AppColors {
  static const Color primary = ...;
  static const Color surface = ...;
  // ... more colors
}
```

---

## 📝 Prompt for Claude (To Fix Image Display)

Use this prompt when asking Claude to debug/fix:

---

### PROMPT FOR CLAUDE

```
I have a Flutter app with Supabase backend. Users/admins add anime with cover images.

**CURRENT ISSUE**: 
- Images UPLOAD to Supabase Storage ✅
- Image filename SAVES to database ✅
- BUT images DON'T DISPLAY in UI ❌

**Architecture**:
- Entity: lib/features/anime/domain/entities/anime_entity.dart (AnimeEntity with imageFileName + coverImageUrl getter)
- Model: lib/features/anime/data/models/anime_model.dart (maps DB json['image_file_name'])
- Remote DS: lib/features/anime/data/datasources/anime_remote_datasource.dart (Supabase CRUD)
- Repository: lib/features/anime/data/repositories/anime_repository_impl.dart (calls remote DS)
- Form: lib/features/anime/presentation/widgets/anime_form_modal.dart (picks image, uploads, returns imageFileName)
- Display: lib/features/anime/presentation/widgets/anime_card.dart (displays image using imageFileName)

**Image Upload Flow**:
1. User picks image in anime_form_modal.dart
2. _saveImageToAssets() uploads to Supabase Storage, returns:
   - Public URL (if http) → e.g., "https://xxx.supabase.co/storage/v1/object/public/anime/xxx"
   - OR web_image:filename (if web, cached locally)
   - OR absolute file path (if mobile, saved locally)
3. imageFileName sent to Supabase DB
4. anime_card.dart reads anime.coverImageUrl (which uses imageFileName from DB)
5. _buildImageProvider() converts to appropriate ImageProvider

**Debug Info**:
- AnimeEntity.coverImageUrl getter handles:
  - "http" URLs → NetworkImage
  - "web_image:" refs → MemoryImage from cache
  - "assets/" → AssetImage
  - file paths → FileImage
- anime_card.dart imports imageCache from anime_form_modal.dart

**What to check**:
1. Is the Supabase public URL format correct? Should start with "https://"
2. Is CORS properly configured in Supabase Storage?
3. Is the image actually being stored in Supabase Storage (check dashboard)?
4. Is anime_card.dart receiving the correct image path from DB?
5. Are there any debug prints showing wrong path format?

**Files to review**:
- anime_form_modal.dart → _saveImageToAssets() return value
- anime_card.dart → _buildImageProvider() logic
- anime_entity.dart → coverImageUrl getter
- anime_remote_datasource.dart → createAnime/updateAnime payloads

Please identify why images aren't displaying despite uploading successfully.
```

---

## 🚀 How to Use This Document with Claude

1. **Copy the folder structure above** → show Claude your exact file layout
2. **Share the prompt at bottom** → Claude understands the problem
3. **Attach any error logs** → from browser console or terminal
4. **Show one problematic file** → paste full content if possible

Claude will then:
- ✅ Understand data flow
- ✅ Identify missing fields/logic
- ✅ Suggest specific code changes
- ✅ Provide complete fixed versions

---

## 📌 Critical Files & Their Purposes

| File | Purpose | Status |
|------|---------|--------|
| `anime_form_modal.dart` | Image pick + Supabase upload | ✅ Implemented |
| `anime_card.dart` | Display anime with image | ✅ Recently updated |
| `anime_entity.dart` | coverImageUrl computation | ✅ Handles all formats |
| `anime_model.dart` | DB mapping (image_file_name) | ✅ Works |
| `anime_remote_datasource.dart` | Supabase CRUD | ✅ Sends imageFileName |
| `supabase_client.dart` | Supabase init + singleton | ✅ Initialized |

---

**Last Updated**: Post-image-upload debugging  
**Status**: Image uploads work; display logic implemented; needs verification
