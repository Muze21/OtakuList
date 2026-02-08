# Database Setup for Admin Features

Run these SQL queries in Supabase SQL Editor to add the required columns.

## 1. Add is_banned column to profiles table

```sql
ALTER TABLE public.profiles 
ADD COLUMN is_banned boolean DEFAULT false;
```

## 2. Check current structure

```sql
SELECT * FROM profiles LIMIT 1;
```

Should have these columns:
- id (UUID) ✓
- email (TEXT) ✓
- username (TEXT) ✓
- avatar_url (TEXT, nullable) ✓
- is_admin (BOOLEAN) ✓ (added previously)
- is_banned (BOOLEAN) ✓ (new)
- created_at (TIMESTAMP) ✓
- updated_at (TIMESTAMP) ✓

## 3. View all users (for admin)

```sql
SELECT id, username, email, is_admin, is_banned, created_at 
FROM profiles 
ORDER BY created_at DESC;
```

## 4. Ban a user

```sql
UPDATE profiles 
SET is_banned = true 
WHERE email = 'user@example.com';
```

## 5. Unban a user

```sql
UPDATE profiles 
SET is_banned = false 
WHERE email = 'user@example.com';
```

## Done!

All database setup complete. Now run `flutter pub get` to ensure all dependencies are synced.
