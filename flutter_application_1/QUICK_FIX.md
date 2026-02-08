# 🚀 QUICK TROUBLESHOOTING GUIDE

## Error Mu:
```
422 Failed to load resource: User already registered
406 Failed to fetch profile: Cannot coerce result
```

## Penyebab:
1. Sudah register dengan email yang sama sebelumnya
2. RLS policy di Supabase belum setup dengan benar untuk INSERT/SELECT

## ✅ Langkah Perbaikan (Pilih SATU):

### CARA 1: Quick Test (Disable RLS dulu)
```sql
-- Run di Supabase SQL Editor:
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE anime DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_anime DISABLE ROW LEVEL SECURITY;
```
Terus coba register pakai EMAIL BARU di app. Kalau berhasil, berarti masalahnya di RLS policy.

### CARA 2: Proper Fix (Setup RLS dengan benar)
1. Buka file `SUPABASE_RLS_FIX.md`
2. Copy-paste SQL dari bagian "SQL FIXES"
3. Run di Supabase SQL Editor
4. Coba register pakai EMAIL BARU

### CARA 3: Gunakan Email Lama
Kalau pengen reuse email yang sama:
```sql
-- Delete profile lama:
DELETE FROM profiles WHERE email = 'emailmu@example.com';

-- ATAU delete dari auth juga:
-- Go to Supabase Dashboard → Auth Users → find user → delete
-- Then coba register ulang
```

---

## 🧪 Testing Setelah Fix:

1. **Register:**
   - Email: `newuser@test.com` (EMAIL BARU!)
   - Username: `testuser123`
   - Password: `password123`
   - Click "Create Account"

2. **Check Supabase:**
   - Buka Supabase Dashboard
   - Table `profiles` → lihat ada row baru gak?

3. **Login:**
   - Gunakan email & password dari step 1
   - Harus navigate ke anime page

---

## 📞 Kalau Masih Error:

Share screenshot/error message dari:
1. Supabase SQL Editor (output dari SQL fixes)
2. Flutter console saat register/login
3. Supabase Dashboard → profiles table (lihat ada data gak)

---

**Try CARA 1 dulu untuk test!** 🚀
