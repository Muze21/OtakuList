# DATABASE SCHEMA & RELASI ENTITAS

## A. ENTITY STRUCTURE

### 1. ANIME Entity
```
Anime {
  id: String (PK)
  title: String
  synopsis: String?
  imageUrl: String?
  episodes: int
  rating: double
  genres: List<String>
  status: AnimeStatus (Ongoing | Completed | Upcoming | Hiatus)
  year: int?
  studio: String?
  createdAt: DateTime
  updatedAt: DateTime?
}
```

### 2. PROFILE Entity  
```
Profile {
  id: String (PK/User ID)
  email: String
  username: String
  avatarUrl: String?
  bio: String?
  role: UserRole (user | admin | banned)
  createdAt: DateTime
  updatedAt: DateTime?
}
```

### 3. REVIEW Entity
```
Review {
  id: String (PK)
  userId: String (FK → Profile.id)
  animeId: String (FK → Anime.id)
  content: String
  rating: double (0-10)
  user: Profile? (Optional relation object)
  createdAt: DateTime
  updatedAt: DateTime?
}
```

### 4. USER_ANIME Entity
```
UserAnime {
  id: String (PK)
  userId: String (FK → Profile.id)
  animeId: String (FK → Anime.id)
  status: ListStatus (Watching | Completed | On Hold | Dropped | Plan to Watch)
  watchedEpisodes: int?
  rating: double? (0-10)
  notes: String?
  createdAt: DateTime
  updatedAt: DateTime?
}
```

---

## B. RELATIONSHIP MAPPINGS

### Relasi 1: PROFILE → REVIEW (1:Many)
```
┌──────────────────────────────────────────────────────────┐
│ PROFILE (1)                    (N) REVIEW                │
├──────────────────────────────────────────────────────────┤
│ id                             userId (Foreign Key)      │
│ email                      ─┬──→ animeId                 │
│ username                   │   content                   │
│ avatarUrl                  │   rating                    │
│ bio                        │   createdAt                 │
│ role                       │   updatedAt                 │
│ createdAt                  │                             │
│ updatedAt                  │                             │
└──────────────────────────────────────────────────────────┘

Mapping:
  • 1 User dapat membuat BANYAK Review
  • SETIAP Review milik SATU User (creator)
  • Relasi dibuktikan via: Review.userId = Profile.id
  • Cardinality: 1:N (One-to-Many)
```

### Relasi 2: ANIME → REVIEW (1:Many)
```
┌──────────────────────────────────────────────────────────┐
│ ANIME (1)                      (N) REVIEW                │
├──────────────────────────────────────────────────────────┤
│ id                             animeId (Foreign Key)     │
│ title                      ─┬──→ userId                  │
│ synopsis                   │   content                   │
│ imageUrl                   │   rating                    │
│ episodes                   │   createdAt                 │
│ rating                     │   updatedAt                 │
│ genres                     │                             │
│ status                     │                             │
│ year                       │                             │
│ studio                     │                             │
│ createdAt                  │                             │
│ updatedAt                  │                             │
└──────────────────────────────────────────────────────────┘

Mapping:
  • 1 Anime dapat punya BANYAK Review
  • SETIAP Review tentang SATU Anime
  • Relasi dibuktikan via: Review.animeId = Anime.id
  • Cardinality: 1:N (One-to-Many)
```

### Relasi 3: PROFILE → USER_ANIME (1:Many)
```
┌──────────────────────────────────────────────────────────┐
│ PROFILE (1)               (N) USER_ANIME                 │
├──────────────────────────────────────────────────────────┤
│ id                        userId (Foreign Key)           │
│ email                ─┬───→ animeId                      │
│ username            │    status                         │
│ avatarUrl           │    watchedEpisodes                │
│ bio                 │    rating                         │
│ role                │    notes                          │
│ createdAt           │    createdAt                      │
│ updatedAt           │    updatedAt                      │
└──────────────────────────────────────────────────────────┘

Mapping:
  • 1 User dapat menambahkan BANYAK Anime ke watchlist
  • SETIAP entry di user list milik SATU User
  • Relasi dibuktikan via: UserAnime.userId = Profile.id
  • Cardinality: 1:N (One-to-Many)
  • Gunakan: Track watchlist, rating personal, notes
```

### Relasi 4: ANIME → USER_ANIME (1:Many)
```
┌──────────────────────────────────────────────────────────┐
│ ANIME (1)                 (N) USER_ANIME                 │
├──────────────────────────────────────────────────────────┤
│ id                        animeId (Foreign Key)          │
│ title                ─┬───→ userId                       │
│ episodes            │    status                         │
│ rating              │    watchedEpisodes                │
│ genres              │    rating                         │
│ status              │    notes                          │
│ ...                 │    createdAt                      │
└──────────────────────────────────────────────────────────┘

Mapping:
  • 1 Anime dapat ada di BANYAK user's watchlist
  • SETIAP entry di list mereferensi SATU Anime
  • Relasi dibuktikan via: UserAnime.animeId = Anime.id
  • Cardinality: 1:N (One-to-Many)
  • Gunakan: Popular anime tracking, user ratings
```

### Relasi 5: PROFILE ⊕ REVIEW (Optional 1:1)
```
┌──────────────────────────────────────────────────────────┐
│ PROFILE (1)              (0..1) REVIEW.user              │
├──────────────────────────────────────────────────────────┤
│ id                            (Embedded/Referenced)      │
│ email                    ─┬──→ Pengguna info di Review   │
│ username                │    (Nested object)            │
│ avatarUrl               │                               │
│ bio                     │                               │
│ role                    │                               │
│ createdAt               │                               │
│ updatedAt               │                               │
└──────────────────────────────────────────────────────────┘

Mapping:
  • OPTIONAL: Review bisa include Profile object
  • Digunakan untuk: Display reviewer info tanpa join query
  • Stored in: Review.user (Profile?)
  • Cardinality: 1:0..1 (Optional)
  • DB Ref: denormalisasi untuk performa read
```

---

## C. COMPLETE ER DIAGRAM

```
                    ┌──────────────────┐
                    │     PROFILE      │
                    ├──────────────────┤
                    │ id (PK)          │
                    │ email            │
                    │ username         │
                    │ avatarUrl        │
                    │ bio              │
                    │ role             │
                    │ createdAt        │
                    │ updatedAt        │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              Creates (1:N)    Has in List (1:N)
                    │                 │
                    ▼                 ▼
            ┌──────────────────┐  ┌──────────────────┐
            │     REVIEW       │  │   USER_ANIME     │
            ├──────────────────┤  ├──────────────────┤
            │ id (PK)          │  │ id (PK)          │
            │ userId (FK)      │  │ userId (FK)      │
            │ animeId (FK)     │  │ animeId (FK)     │
            │ content          │  │ status           │
            │ rating           │  │ watchedEpisodes  │
            │ user (optional)  │  │ rating           │
            │ createdAt        │  │ notes            │
            │ updatedAt        │  │ createdAt        │
            └────────┬─────────┘  │ updatedAt        │
                     │            └────────┬─────────┘
                     │                     │
           About (1:N)              References (1:N)
                     │                     │
                     └─────────┬───────────┘
                               │
                               ▼
                     ┌──────────────────┐
                     │      ANIME       │
                     ├──────────────────┤
                     │ id (PK)          │
                     │ title            │
                     │ synopsis         │
                     │ imageUrl         │
                     │ episodes         │
                     │ rating           │
                     │ genres[]         │
                     │ status           │
                     │ year             │
                     │ studio           │
                     │ createdAt        │
                     │ updatedAt        │
                     └──────────────────┘
```

---

## D. TABEL RELASI LENGKAP

| No | Relasi | From Entity | To Entity | Type | Foreign Key | Cardinality | Deskripsi |
|----|--------|-------------|-----------|------|-------------|-------------|-----------|
| 1 | createdBy | REVIEW | PROFILE | 1:N | review.userId → profile.id | 1:N | User membuat review |
| 2 | about | REVIEW | ANIME | N:1 | review.animeId → anime.id | N:1 | Review tentang anime |
| 3 | addedBy | USER_ANIME | PROFILE | 1:N | user_anime.userId → profile.id | 1:N | User add ke watchlist |
| 4 | inList | USER_ANIME | ANIME | N:1 | user_anime.animeId → anime.id | N:1 | Anime ada di list |
| 5 | creator | REVIEW | PROFILE | 1:1 | review.user (embedded) | 1:0..1 | Reviewer info (optional) |

---

## E. JOIN EXAMPLES

### Query 1: Dapatkan semua reviews untuk anime X dengan user info
```
SELECT r.*, p.* 
FROM REVIEW r
JOIN PROFILE p ON r.userId = p.id
WHERE r.animeId = 'anime_123'
```

### Query 2: Dapatkan watchlist user dengan detail anime
```
SELECT ua.*, a.* 
FROM USER_ANIME ua
JOIN ANIME a ON ua.animeId = a.id
WHERE ua.userId = 'user_456'
```

### Query 3: Dapatkan anime dengan average rating dari reviews
```
SELECT a.*, AVG(r.rating) as avgRating, COUNT(r.id) as reviewCount
FROM ANIME a
LEFT JOIN REVIEW r ON a.id = r.animeId
GROUP BY a.id
```

### Query 4: Dapatkan user's watched anime dengan personal rating
```
SELECT ua.*, a.title, a.imageUrl, a.rating as animeRating
FROM USER_ANIME ua
JOIN ANIME a ON ua.animeId = a.id
WHERE ua.userId = 'user_789' AND ua.status = 'Completed'
```

---

## F. NORMALIZATION STATUS

### Entities yang sudah normalized:
- ✅ ANIME - Sudah 3NF
- ✅ PROFILE - Sudah 3NF
- ✅ REVIEW - Sudah 3NF
- ✅ USER_ANIME - Sudah 3NF
- ✅ Foreign keys digunakan dengan benar
- ✅ Tidak ada redundansi data

### Denormalisasi yang sengaja dilakukan:
- ✅ Review.user (Profile object) - untuk performa read
- ✅ User watchlist tracking - untuk analytics

---

## G. DATA FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────────┐
│                     USER INTERACTION                        │
└──────────────────────────┬──────────────────────────────────┘
                           │
                ┌──────────┴──────────┐
                │                     │
         ┌──────▼─────┐       ┌──────▼──────┐
         │ Login/Auth  │       │ Browse App  │
         └──────┬─────┘       └──────┬──────┘
                │                    │
         ┌──────▼─────────────────┬──┴──────────┐
         │  Create PROFILE       │             │
         │  (Supabase Auth)      │             │
         └──────────────────────┬┘  View Anime │
                                │   List      │
                                │  (Read)     │
                    ┌───────────┴─────────┐   │
                    │                     │   │
            ┌───────▼────┐         ┌──────▼──────┐
            │ Add Anime  │         │ Click Anime │
            │ to List    │         │   Detail    │
            │ (Create    │         │   (Read)    │
            │ USER_ANIME)│         └──────┬──────┘
            └───────┬────┘                │
                    │         ┌──────────┬┘
                    │         │
            ┌───────▼──────────▼────────┐
            │ Write/Read Review         │
            │ (Create/Read REVIEW)      │
            │ (Update rating in         │
            │  USER_ANIME)              │
            └───────────────────────────┘
```

---

## H. INTEGRITY CONSTRAINTS

### Primary Keys:
- ANIME.id (String, Unique)
- PROFILE.id (String, dari Auth, Unique)
- REVIEW.id (String, Unique)
- USER_ANIME.id (String, Unique)

### Foreign Keys:
- REVIEW.userId → PROFILE.id (NOT NULL, Cascade Delete)
- REVIEW.animeId → ANIME.id (NOT NULL, Cascade Delete)
- USER_ANIME.userId → PROFILE.id (NOT NULL, Cascade Delete)
- USER_ANIME.animeId → ANIME.id (NOT NULL, Cascade Delete)

### Unique Constraints:
- PROFILE.email (UNIQUE)
- REVIEW(userId, animeId) - Setiap user hanya 1 review per anime
- USER_ANIME(userId, animeId) - Setiap user hanya 1 entry per anime

### Check Constraints:
- REVIEW.rating: 0 ≤ rating ≤ 10
- USER_ANIME.rating: 0 ≤ rating ≤ 10 (optional)
- USER_ANIME.watchedEpisodes: ≥ 0 dan ≤ ANIME.episodes
- ANIME.episodes: > 0
- ANIME.rating: 0 ≤ rating ≤ 10

---

**Last Updated**: 9 Januari 2026
**Database**: Supabase PostgreSQL
