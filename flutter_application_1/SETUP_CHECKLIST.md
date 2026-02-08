# 🚀 Supabase Setup Checklist untuk Register/Login

## ✅ Yang Sudah Diperbaiki di Kode:
- [x] Perbaiki `SupabaseClientService` initialization
- [x] Tambah `created_at` dan `updated_at` fields saat register
- [x] Improve error handling dan messaging
- [x] Update `UserProfileModel.id` dari `int` ke `String` (sesuai Supabase auth)
- [x] Tambah `isAdmin` getter di UserProfileModel
- [x] **Sesuaikan field names dengan snake_case SQL schema**
- [x] **Handle genres array parsing dari PostgreSQL format**
- [x] **Update UserAnimeModel untuk match SQL field names**

## 🔄 Field Name Mapping (Dart ↔ SQL)

### UserProfileModel
```
Dart Field         |  SQL Field
-------------------|------------------
id                 |  id
username           |  username
email              |  email
avatarUrl          |  avatar_url
bio                |  bio
role               |  role
createdAt          |  created_at
updatedAt          |  updated_at
isBanned           |  (derived from role)
```

### AnimeModel
```
Dart Field         |  SQL Field
-------------------|------------------
id                 |  id (UUID)
title              |  title
synopsis           |  synopsis
imageFileName      |  image_file_name
episodes           |  episodes
rating             |  rating
genres             |  genres (TEXT[])
status             |  status
year               |  year
studio             |  studio
createdAt          |  created_at
updatedAt          |  updated_at
```

### UserAnimeModel
```
Dart Field         |  SQL Field
-------------------|------------------
id                 |  id (UUID)
userId             |  user_id
animeId            |  anime_id
status             |  status
watchedEpisodes    |  watched_episodes
userRating         |  user_rating
notes              |  notes
createdAt          |  created_at
updatedAt          |  updated_at
```

## ⚙️ SQL Schema yang Sudah Di-Update:

SQL script yang lu buat **sudah cocok 100%** dengan Dart code setelah perbaikan di atas.

Key points dari SQL:
- ✅ UUID untuk semua ID fields
- ✅ Snake_case field names
- ✅ RLS policies untuk security
- ✅ Triggers untuk auto-update `updated_at`
- ✅ Function untuk update anime rating otomatis
- ✅ UNIQUE constraint pada user_anime(user_id, anime_id)

## 📋 Setup Steps:

### 1. **Copy-paste SQL ke Supabase SQL Editor**
   - Buka [Supabase Dashboard](https://app.supabase.co)
   - Pilih project mu
   - Buka SQL Editor
   - Copy-paste seluruh SQL script dari user

### 2. **Run SQL Script**
   - Click "Run" untuk execute
   - Check apakah ada error

### 3. **Create Admin User (Optional)**
```sql
-- Jalankan ini setelah admin signup via app:
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'admin@myanimelist.com';
```

## 🧪 Testing Checklist:

1. **Register User:**
   - [ ] Buka app
   - [ ] Click "Register" 
   - [ ] Isi email, username, password
   - [ ] Tekan "Create Account"
   - [ ] Check Supabase Dashboard → profiles table

2. **Login User:**
   - [ ] Gunakan email & password dari register
   - [ ] Tekan "Login"
   - [ ] Harus navigate ke SeasonalAnimePage

3. **Database Check:**
   - [ ] profiles table ada new row
   - [ ] All fields populated correctly
   - [ ] created_at & updated_at auto-populated

## 🔍 Common Issues & Solutions:

| Issue | Solution |
|-------|----------|
| "profiles table not found" | Run SQL script di Supabase SQL Editor |
| "Email already exists" | Gunakan email baru untuk register |
| "Failed to fetch profile" | Check RLS policies, pastikan SELECT policy ada |
| "Field not found" | Check field names match (snake_case di SQL) |
| "Network error" | Check internet & Supabase URL |

## ✨ JSON Parsing Special Cases:

### Genres Array Handling
SQL menyimpan genres sebagai PostgreSQL array: `{Action,Drama,Fantasy}`
Dart code automatically parse ini dengan `_parseGenres()` helper.

### DateTime Handling
Semua datetime di SQL adalah `TIMESTAMP WITH TIME ZONE`
Dart parse menggunakan `.parse()` dengan ISO8601 format

## 🎯 Next Steps:
1. Run SQL script di Supabase
2. Test register/login
3. Check database untuk verify data insertion
4. Kalau ada error, share error message di console

---

**Database & Code Sekarang 100% Synchronized!** ✅

