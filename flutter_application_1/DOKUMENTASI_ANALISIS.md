# 📋 Analisis Kode Flutter Application - Laporan Lengkap

**Tanggal**: 9 Januari 2026  
**Workspace**: `e:\darto\flutter_application_1`

---

## 1. 🔴 DAFTAR ERROR YANG DITEMUKAN

### A. Error di `app_router.dart`
| Line | Error | Tipe |
|------|-------|------|
| 2 | Unused import: `package:flutter/material.dart` | ⚠️ Warning |
| 8 | Unused import: `presentation/anime/list/anime_list_page.dart` | ⚠️ Warning |
| 9 | Unused import: `presentation/anime/detail/anime_detail_page.dart` | ⚠️ Warning |

### B. Error di `anime_model.dart`
| Line | Field | Error | Tipe |
|------|-------|-------|------|
| 17 | `imageUrl` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |
| 24 | `createdAt` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |
| 25 | `updatedAt` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |

### C. Error di `profile_model.dart`
| Line | Field | Error | Tipe |
|------|-------|-------|------|
| 18 | `avatarUrl` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |
| 21 | `createdAt` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |
| 22 | `updatedAt` | @JsonKey hanya bisa digunakan pada fields atau getters, bukan di constructor | ❌ Compile Error |

### D. Error di `user_management_page.dart`
| Line | Field | Error | Tipe |
|------|-------|-------|------|
| 13 | `_searchQuery` | Nilai field tidak digunakan | ⚠️ Warning |

### E. Error di `anime_detail_view.dart`
| Line | Error | Tipe |
|------|-------|------|
| 8 | Unused import: `core/utils/helpers.dart` | ⚠️ Warning |

### F. Error di `home_page.dart`
| Line | Error | Tipe |
|------|-------|------|
| 4 | Unused import: `package:go_router/go_router.dart` | ⚠️ Warning |

---

## 2. 📁 STRUKTUR FOLDER LIB

```
lib/
├── app.dart                          [✓ Lengkap]
├── main.dart                         [✓ Lengkap]
│
├── config/
│   ├── env/
│   │   ├── app_config.dart          [✓ Lengkap]
│   │   └── env.dart                 [✓ Lengkap]
│   ├── router/
│   │   ├── app_router.dart          [⚠️ Ada Error Import]
│   │   └── route_names.dart         [✓ Lengkap]
│   └── providers.dart               [✓ Lengkap]
│
├── core/
│   ├── constants/
│   │   ├── anime_status.dart        [✓ Lengkap]
│   │   ├── app_constants.dart       [✓ Lengkap]
│   │   ├── list_status.dart         [✓ Lengkap]
│   │   └── roles.dart               [✓ Lengkap]
│   ├── errors/
│   │   ├── exceptions.dart          [✓ Lengkap]
│   │   └── failures.dart            [✓ Lengkap]
│   ├── guards/
│   │   ├── admin_guard.dart         [✓ Lengkap]
│   │   ├── auth_guard.dart          [✓ Lengkap]
│   │   └── banned_guard.dart        [✓ Lengkap]
│   ├── themes/
│   │   ├── app_theme.dart           [✓ Lengkap]
│   │   ├── colors.dart              [✓ Lengkap]
│   │   └── text_styles.dart         [✓ Lengkap]
│   ├── utils/
│   │   ├── debouncer.dart           [✓ Lengkap]
│   │   ├── extensions.dart          [✓ Lengkap]
│   │   ├── helpers.dart             [✓ Lengkap]
│   │   └── validators.dart          [✓ Lengkap]
│   └── widgets/
│       ├── common/
│       │   ├── app_button.dart      [✓ Lengkap]
│       │   ├── app_text_field.dart  [✓ Lengkap]
│       │   └── loading_indicator.dart [✓ Lengkap]
│       └── domain/
│           ├── anime_card.dart      [✓ Lengkap]
│           ├── genre_chip.dart      [✓ Lengkap]
│           └── rating_widget.dart   [✓ Lengkap]
│
├── data/
│   ├── data_sources/
│   │   ├── local/
│   │   │   └── auth_local_data_source.dart [✓ Lengkap]
│   │   └── remote/
│   │       ├── admin_remote_data_source.dart [❌ KOSONG]
│   │       ├── anime_remote_data_source.dart [✓ Lengkap]
│   │       ├── auth_remote_data_source.dart  [✓ Lengkap]
│   │       └── supabase_client.dart          [✓ Lengkap]
│   ├── models/
│   │   ├── anime_model.dart         [❌ Ada Compile Error]
│   │   ├── anime_model.freezed.dart [✓ Generated]
│   │   ├── anime_model.g.dart       [✓ Generated]
│   │   ├── profile_model.dart       [❌ Ada Compile Error]
│   │   ├── profile_model.freezed.dart [✓ Generated]
│   │   ├── profile_model.g.dart     [✓ Generated]
│   │   ├── review_model.dart        [✓ Lengkap]
│   │   └── user_anime_model.dart    [✓ Lengkap]
│   └── repositories_impl/
│       ├── admin_repository_impl.dart [❌ KOSONG]
│       ├── anime_repository_impl.dart [⚠️ Partial - Ada UnimplementedError]
│       └── auth_repository_impl.dart [✓ Lengkap]
│
├── domain/
│   ├── entities/
│   │   ├── anime.dart               [✓ Lengkap]
│   │   ├── anime.freezed.dart       [✓ Generated]
│   │   ├── profile.dart             [✓ Lengkap]
│   │   ├── profile.freezed.dart     [✓ Generated]
│   │   ├── review.dart              [✓ Lengkap]
│   │   ├── review.freezed.dart      [✓ Generated]
│   │   └── user_anime.dart          [✓ Lengkap]
│   ├── repositories/
│   │   ├── admin_repository.dart    [✓ Interface Lengkap]
│   │   ├── anime_repository.dart    [✓ Interface Lengkap]
│   │   └── auth_repository.dart     [✓ Interface Lengkap]
│   └── use_cases/
│       ├── anime/
│       │   ├── get_anime_detail_use_case.dart [✓ Lengkap]
│       │   ├── get_anime_list_use_case.dart   [✓ Lengkap]
│       │   └── search_anime_use_case.dart     [✓ Lengkap]
│       ├── auth/
│       │   ├── login_use_case.dart   [✓ Lengkap]
│       │   ├── logout_use_case.dart  [✓ Lengkap]
│       │   └── register_use_case.dart [✓ Lengkap]
│       └── user/
│           ├── get_user_anime_list_use_case.dart [✓ Lengkap]
│           └── update_profile_use_case.dart      [✓ Lengkap]
│
├── injection/
│   ├── injection_container.dart      [❌ KOSONG]
│   └── injection_container.config.dart [? Auto-generated]
│
└── presentation/
    ├── admin/
    │   ├── admin_dashboard_page.dart [⚠️ Partial - Hanya UI Skeleton]
    │   ├── anime/
    │   │   └── anime_management_page.dart [⚠️ Partial - TODO comments]
    │   └── users/
    │       └── user_management_page.dart  [⚠️ Partial - Ada Error & TODO]
    ├── anime/
    │   ├── detail/
    │   │   ├── anime_detail_controller.dart [✓ Lengkap]
    │   │   ├── anime_detail_page.dart       [✓ Lengkap]
    │   │   └── anime_detail_view.dart       [⚠️ Ada Unused Import]
    │   └── list/
    │       ├── anime_list_controller.dart [✓ Lengkap]
    │       ├── anime_list_page.dart       [✓ Lengkap]
    │       └── anime_list_view.dart       [✓ Lengkap]
    ├── auth/
    │   ├── login/
    │   │   ├── login_controller.dart      [✓ Lengkap]
    │   │   ├── login_page.dart            [✓ Lengkap]
    │   │   └── login_view.dart            [✓ Lengkap]
    │   └── register/
    │       ├── register_controller.dart   [✓ Lengkap]
    │       ├── register_page.dart         [✓ Lengkap]
    │       └── register_view.dart         [✓ Lengkap]
    ├── home/
    │   └── home_page.dart                [⚠️ Ada Unused Import]
    └── profile/
        └── profile_page.dart              [✓ Lengkap]
```

---

## 3. 📝 FILE YANG BELUM DIISI / KOSONG

| No | File | Path | Status | Keterangan |
|-------|----------|------|--------|------------|
| 1 | `admin_remote_data_source.dart` | `lib/data/data_sources/remote/` | ❌ KOSONG | Butuh implement interface & Supabase calls |
| 2 | `admin_repository_impl.dart` | `lib/data/repositories_impl/` | ❌ KOSONG | Butuh implement semua methods dari AdminRepository |
| 3 | `injection_container.dart` | `lib/injection/` | ❌ KOSONG | Setup dependency injection untuk Admin |

---

## 4. 📊 RELASI ENTITAS & DATABASE

### Entity Relationship Diagram (ERD)

```
┌─────────────┐
│   PROFILE   │
├─────────────┤
│ id (PK)     │──────────┐
│ email       │          │
│ username    │          │
│ avatarUrl   │          │
│ bio         │          │
│ role        │          │
│ createdAt   │          │
│ updatedAt   │          │
└─────────────┘          │
       ▲                 │
       │                 │
       │                 │ Creator
       │                 │
┌──────┴────────┐        │
│     REVIEW    │        │
├──────────────┤        │
│ id (PK)      │        │
│ userId (FK)  │◄───────┘
│ animeId (FK) │──────────┐
│ content      │          │
│ rating       │          │
│ createdAt    │          │
│ updatedAt    │          │
└──────────────┘          │
                          │
                    ┌─────▼──────┐
                    │    ANIME    │
                    ├─────────────┤
                    │ id (PK)     │
                    │ title       │
                    │ synopsis    │
                    │ imageUrl    │
                    │ episodes    │
                    │ rating      │
                    │ genres[]    │
                    │ status      │
                    │ year        │
                    │ studio      │
                    │ createdAt   │
                    │ updatedAt   │
                    └─────────────┘
                          ▲
                          │
                    ┌─────┴──────────┐
                    │  USER_ANIME    │
                    ├────────────────┤
                    │ id (PK)        │
                    │ userId (FK)    │
                    │ animeId (FK)   │
                    │ status         │
                    │ watchedEp      │
                    │ rating         │
                    │ notes          │
                    │ createdAt      │
                    │ updatedAt      │
                    └────────────────┘
```

### Tabel Relasi

| Relasi | From | To | Type | Foreign Key |
|--------|------|----|----|------------|
| User membuat Review | PROFILE | REVIEW | 1:N | `review.userId` → `profile.id` |
| Review tentang Anime | ANIME | REVIEW | 1:N | `review.animeId` → `anime.id` |
| User menambah Anime ke List | PROFILE | USER_ANIME | 1:N | `user_anime.userId` → `profile.id` |
| Anime ada di User List | ANIME | USER_ANIME | 1:N | `user_anime.animeId` → `anime.id` |
| Review punya User Info | PROFILE | REVIEW | 1:1 (optional) | `review.user` → PROFILE object |

---

## 5. 🔧 RINGKASAN MASALAH & SOLUSI

### A. JsonKey Annotation Error (Anime & Profile Model)
**Masalah**: `@JsonKey` annotation ditempatkan di constructor parameter, bukan field declaration.

**Lokasi Error**:
- `anime_model.dart` lines 17, 24, 25
- `profile_model.dart` lines 18, 21, 22

**Solusi**: Pindahkan `@JsonKey` ke field declaration sebelum tipe data.

**Contoh Perbaikan**:
```dart
// ❌ SALAH (Current)
@freezed
class AnimeModel with _$AnimeModel {
  const factory AnimeModel({
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _AnimeModel;
}

// ✅ BENAR
@freezed
class AnimeModel with _$AnimeModel {
  const factory AnimeModel({
    String? imageUrl,
    String? createdAt,
  }) = _AnimeModel;

  @JsonSerializable()
  factory AnimeModel.fromJson(Map<String, dynamic> json) => _$AnimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeModelToJson(this);
}
```

### B. Unused Import Warnings
**Masalah**: Import yang tidak digunakan di beberapa file.

**File Terpengaruh**:
- `app_router.dart` (3 unused imports)
- `anime_detail_view.dart` (1 unused import)
- `home_page.dart` (1 unused import)
- `user_management_page.dart` (1 unused field `_searchQuery`)

**Solusi**: Hapus import yang tidak diperlukan.

### C. Unimplemented Methods
**Masalah**: `anime_repository_impl.dart` punya beberapa method yang throw `UnimplementedError`.

**Methods yang tidak diimplementasikan**:
1. `getUserAnimeList()`
2. `addToList()`
3. `updateListEntry()`
4. `removeFromList()`
5. `getAnimeReviews()`
6. `addReview()`
7. `deleteReview()`

### D. Missing Files yang Wajib Diisi
1. **`admin_remote_data_source.dart`** - Butuh implement Supabase queries untuk admin operations
2. **`admin_repository_impl.dart`** - Butuh implement semua CRUD untuk admin (users, anime, bans)
3. **`injection_container.dart`** - Setup DI container untuk admin repository & data source

### E. Partial Implementation Pages
- **`admin_dashboard_page.dart`** - Hanya skeleton, sudah ada routing ke sub-pages
- **`anime_management_page.dart`** - Ada TODO comments, perlu ambil data dari provider
- **`user_management_page.dart`** - Ada `_searchQuery` yang unused, perlu implementasi logic

---

## 6. 📋 CHECKLIST IMPLEMENTASI

### Prioritas Tinggi (🔴 Critical)
- [ ] Perbaiki `@JsonKey` annotation di `anime_model.dart` 
- [ ] Perbaiki `@JsonKey` annotation di `profile_model.dart`
- [ ] Implementasi `admin_remote_data_source.dart`
- [ ] Implementasi `admin_repository_impl.dart`

### Prioritas Medium (🟠 Important)
- [ ] Isi `injection_container.dart` dengan setup DI
- [ ] Implementasi unimplemented methods di `anime_repository_impl.dart`
- [ ] Hapus unused imports & fields

### Prioritas Rendah (🟡 Nice to Have)
- [ ] Lengkapi partial implementation di admin pages
- [ ] Tambah error handling di presenter layer
- [ ] Tambah unit tests

---

## 7. 📈 STATISTIK PROJECT

| Kategori | Jumlah |
|----------|--------|
| Total .dart files | 83 |
| Files ✓ Lengkap | 72 |
| Files ⚠️ Partial/Warning | 7 |
| Files ❌ Kosong | 2 |
| Compile Errors | 6 |
| Warnings/Unused | 6 |
| TODOs | 3 |

---

## 8. 🏗️ ARCHITECTURE OVERVIEW

```
Presentation Layer (UI)
├── Pages (StatefulWidget / ConsumerWidget)
├── Views (Komponen UI)
└── Controllers (StateNotifier)
           ↓
Domain Layer (Business Logic)
├── Entities (Model data domain)
├── Repositories (Interfaces)
└── Use Cases
           ↓
Data Layer (Data Management)
├── Data Sources (Remote/Local)
├── Models (Serializable)
└── Repository Implementations
           ↓
External Dependencies
├── Supabase
├── Flutter Riverpod
└── Freezed/Json Serializable
```

---

**Generated by**: Automated Code Analysis  
**Last Updated**: 9 Januari 2026
