# 🐛 SUPABASE RLS POLICIES FIX

## Masalah:
1. Registration: 422 error (user already registered)
2. Login: 406 error (cannot fetch profile)

## Root Cause:
RLS policies untuk INSERT dan SELECT tidak setup dengan benar di `profiles` table.

## ✅ SQL FIXES - Run di Supabase SQL Editor:

### 1. DROP existing policies (jika ada)
```sql
DROP POLICY IF EXISTS "Profiles viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
```

### 2. CREATE proper RLS policies untuk PROFILES
```sql
-- Allow users to view their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Allow users to insert their own profile during signup
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow anyone (unauthenticated) to read all profiles (untuk display user info)
-- OPTIONAL - uncomment jika perlu public profile
-- CREATE POLICY "Profiles are public"
--   ON profiles FOR SELECT
--   USING (true);
```

### 3. Verify RLS is ENABLED
```sql
-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'profiles';

-- Output should show: rowsecurity = true
```

### 4. Test Profile Insert
```sql
-- Test: Try insert profile dengan UUID tertentu
-- Ganti UUID_DARI_SIGNUP dengan actual user ID dari Supabase Auth
INSERT INTO profiles (id, email, username, avatar_url, bio, role)
VALUES (
  'UUID_DARI_SIGNUP',
  'testuser@example.com',
  'testuser',
  'default_avatar.png',
  '',
  'user'
);
```

---

## 🔧 Alternative Fix (Simpler - Allow all for now):

Jika RLS policy masih kompleks, temporary remove RLS untuk testing:

```sql
-- TEMPORARY: Disable RLS untuk debug
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE anime DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_anime DISABLE ROW LEVEL SECURITY;

-- THEN test register/login

-- AFTER working, re-enable:
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE anime ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_anime ENABLE ROW LEVEL SECURITY;
```

---

## 📋 What to Do Next:

### Option A: Quick Fix (Temporary)
1. Run the "Alternative Fix" (disable RLS)
2. Try register/login again with **NEW EMAIL**
3. If works, then we know it's RLS policy issue

### Option B: Proper Fix
1. Run the "SQL FIXES" section
2. Try register/login with **NEW EMAIL**
3. Should work with RLS enabled

### Option C: Delete Old User
```sql
-- If you want to re-use the same email:
-- First delete from profiles
DELETE FROM profiles WHERE email = 'email@example.com';

-- Supabase Auth user akan tetap ada, tapi bisa register ulang
```

---

## 🧪 Testing Checklist:

**Before trying anything:**
- ✅ Punya NEW email address (jangan reuse)
- ✅ Check Supabase Dashboard untuk verify tables ada

**After running SQL fixes:**
- [ ] Coba register dengan email baru
- [ ] Check profiles table - ada row baru gak?
- [ ] Coba login dengan email & password sama
- [ ] Harus navigate ke SeasonalAnimePage

---

## ⚠️ Common Issues:

| Error | Cause | Solution |
|-------|-------|----------|
| 422 on signup | User/email already exists | Use new email |
| 406 on profile fetch | RLS policy blocks SELECT | Enable all policies or disable RLS |
| 400 on insert | Missing required fields | Check schema - all fields required? |
| UNIQUE constraint | Email/username duplicate | Delete row atau use different values |

---

## 🔍 Debug Commands:

```sql
-- Check all policies on profiles table
SELECT schemaname, tablename, policyname, permissive, roles, qual, with_check
FROM pg_policies
WHERE tablename = 'profiles';

-- Check RLS status
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename IN ('profiles', 'anime', 'user_anime');

-- Check all rows in profiles
SELECT id, email, username, role, created_at
FROM profiles
ORDER BY created_at DESC;

-- Check latest auth user
SELECT id, email, created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 1;
```

---

**Status: NEEDS SQL FIX in Supabase Dashboard** 🔧
