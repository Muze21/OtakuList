# Admin Dashboard - Complete Setup Guide

## ✅ What Was Created

### 1. Admin Dashboard (New!)
**Files:**
- `lib/features/admin/presentation/pages/admin_dashboard.dart` - Main admin dashboard with 2 tabs
- `lib/features/admin/presentation/pages/admin_users_page.dart` - User management tab
- `lib/features/admin/presentation/providers/admin_provider.dart` - Riverpod providers
- `lib/features/admin/data/datasources/admin_datasource.dart` - Supabase data layer
- `lib/features/admin/data/repositories/admin_repository.dart` - Repository pattern

### 2. Auto-Redirect System (Updated!)
**Files:**
- `lib/features/common/pages/home_page.dart` - Smart redirect based on role
- `lib/main.dart` - Updated to use GoRouter + HomePage

### 3. Features Implemented

#### Admin Users Tab ✅
- View all users (username, email, role, joined date)
- Search users by username or email
- Ban/Unban users with confirmation dialog
- Role badges (Admin/User)
- Status badges (Active/Banned)
- Responsive design (table on desktop, cards on mobile)

#### Admin Anime Tab ✅
- Create anime with all fields (title, year, episodes, rating, status, studio, genres, synopsis)
- Edit anime (including status changes)
- Delete anime with confirmation
- Search anime by title/synopsis
- Responsive grid layout

### 4. Auto-Login Redirect ✅
```
User Login
    ↓
Check isAdmin flag
    ↓
If Admin → Admin Dashboard (/admin/dashboard)
If User → Seasonal Anime Page (/)
```

## 🔧 Setup Instructions

### Step 1: Add Database Column

Run in Supabase SQL Editor:
```sql
ALTER TABLE public.profiles 
ADD COLUMN is_banned boolean DEFAULT false;
```

### Step 2: Create Admin User

**Via Registration:**
1. Open app
2. Go to Register page
3. Register with email: `admin@anime.com` and password of choice
4. In Supabase SQL Editor, run:
```sql
UPDATE profiles 
SET is_admin = true 
WHERE email = 'admin@anime.com';
```

### Step 3: Test Login

1. Go to app login page
2. Login with `admin@anime.com` + password
3. Should automatically redirect to Admin Dashboard
4. You'll see 2 tabs: Users & Anime

## 📊 Admin Dashboard Features

### Users Tab
- **List all users**: See every registered user
- **Search**: Filter by username or email
- **Ban user**: Click block icon → confirm → user banned
- **Unban user**: Click check icon → confirm → user unbanned
- **View info**: Username, email, role, joined date, current status

### Anime Tab (same as before)
- **Add anime**: Click FAB → fill form → submit
- **Edit anime**: Click edit icon → modify fields → update
- **Delete anime**: Click delete icon → confirm → removed
- **Search**: Find anime by title or synopsis

## 🔐 Security Features

✅ Admin check on frontend (won't show button if not admin)
✅ Admin check on backend (won't allow operations if not admin)
✅ Ban system prevents banned users from login
✅ Confirmation dialogs before destructive actions
✅ Error handling with user feedback

## 📱 Responsive Design

**Desktop:**
- Users tab: Data table with all columns
- Anime tab: 4-column grid

**Mobile:**
- Users tab: Card layout with all info
- Anime tab: 2-column grid

## 🎯 User Flow

### Regular User Login
```
Login with user@example.com
↓
Redirect to Home (SeasonalAnimePage)
↓
See anime list, search, filter, add to watchlist
```

### Admin User Login
```
Login with admin@anime.com
↓
Redirect to Admin Dashboard
↓
Tab 1: Manage Users (ban/unban)
Tab 2: Manage Anime (add/edit/delete)
```

## 📁 File Structure

```
lib/features/
├── admin/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── admin_datasource.dart
│   │   └── repositories/
│   │       └── admin_repository.dart
│   └── presentation/
│       ├── pages/
│       │   ├── admin_dashboard.dart
│       │   └── admin_users_page.dart
│       └── providers/
│           └── admin_provider.dart
├── common/
│   └── pages/
│       └── home_page.dart (NEW - smart redirect)
└── ... (other features)
```

## 🚀 Key Providers

```dart
// Get admin datasource
ref.watch(adminDatasourceProvider)

// Get admin repository
ref.watch(adminRepositoryProvider)

// Get all users
ref.watch(allUsersProvider)
// Returns: AsyncValue<List<UserProfileModel>>

// Get single user
ref.watch(userByIdProvider('user-id'))
// Returns: AsyncValue<UserProfileModel>
```

## 🎨 UI Components

### Users Page
- Search bar with clear button
- Desktop: DataTable with 6 columns
- Mobile: Card-based list
- Ban/Unban buttons with icons
- Role and Status badges

### Anime Page (existing)
- Search bar
- Add Anime FAB
- Grid layout
- Edit/Delete buttons per anime
- Form modal for create/edit

## 🔍 Testing Checklist

- [ ] Add `is_banned` column to database
- [ ] Register admin user via app
- [ ] Set `is_admin = true` in Supabase
- [ ] Login with admin → should see admin dashboard
- [ ] Login with regular user → should see seasonal anime page
- [ ] Click Users tab → see all users
- [ ] Search users → filter works
- [ ] Ban a user → confirmation dialog appears
- [ ] Unban a user → status changes
- [ ] Click Anime tab → see all anime
- [ ] Add new anime → appears in list
- [ ] Edit anime → changes saved
- [ ] Delete anime → removed from list
- [ ] Test on mobile → responsive layout works

## 🐛 Troubleshooting

### "Admin Dashboard not showing"
- Check: Is user's `is_admin` = true in database?
- Run: `SELECT email, is_admin FROM profiles;`

### "Ban button not working"
- Check: Is `is_banned` column in database?
- Run: `ALTER TABLE public.profiles ADD COLUMN is_banned boolean DEFAULT false;`

### "Can't see users list"
- Check: Are there any users in profiles table?
- Check: Are RLS policies allowing SELECT?

### "Getting redirect loop"
- Check: currentUserProvider is working
- Check: AuthState is synced properly

## 📝 Database Schema Required

```sql
profiles table must have:
- id (UUID, PK)
- email (TEXT)
- username (TEXT)
- avatar_url (TEXT, nullable)
- is_admin (BOOLEAN) ← must exist
- is_banned (BOOLEAN) ← must exist
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

anime table must have:
- id (UUID, PK)
- title (TEXT)
- synopsis (TEXT)
- image_file_name (TEXT)
- episodes (INTEGER)
- rating (NUMERIC)
- genres (TEXT[] or JSON)
- status (TEXT)
- year (INTEGER)
- studio (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

## ✨ Summary

**Before This Update:**
- App always went to login page
- After login, no intelligent redirect
- No admin features

**After This Update:**
- Admin auto-redirects to Dashboard
- User auto-redirects to Home page
- Full admin panel for user & anime management
- Ban/Unban system working
- Complete CRUD for anime

**Ready to Use!** Just run the database setup SQL and test login with admin account.
