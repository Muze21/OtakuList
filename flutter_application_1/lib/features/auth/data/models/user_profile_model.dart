class UserProfileModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final bool isAdmin; // Changed from role to isAdmin boolean
  final bool isBanned;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.isAdmin,
    required this.isBanned,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      isAdmin: json['is_admin'] ?? false, // Map from is_admin column
      isBanned: json['is_banned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'is_admin': isAdmin, // Map to is_admin column
      'is_banned': isBanned,
    };
  }

  bool get isAdminUser => isAdmin; // Keep getter for backward compatibility

  String get joinDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  String get memberSince {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    
    if (diff.inDays < 30) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 365) {
      final months = diff.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = diff.inDays ~/ 365;
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}

class UserStats {
  final int totalAnimeWatched;
  final int totalEpisodesWatched;
  final double averageRating;
  final int totalWatching;
  final int totalCompleted;
  final int totalPlanned;
  final int totalDropped;

  UserStats({
    required this.totalAnimeWatched,
    required this.totalEpisodesWatched,
    required this.averageRating,
    required this.totalWatching,
    required this.totalCompleted,
    required this.totalPlanned,
    required this.totalDropped,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalAnimeWatched: json['total_anime_watched'] ?? 0,
      totalEpisodesWatched: json['total_episodes_watched'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalWatching: json['total_watching'] ?? 0,
      totalCompleted: json['total_completed'] ?? 0,
      totalPlanned: json['total_planned'] ?? 0,
      totalDropped: json['total_dropped'] ?? 0,
    );
  }

  int get totalAnime => totalWatching + totalCompleted + totalPlanned + totalDropped;
}