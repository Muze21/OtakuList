import 'package:flutter_application_1/core/constants/api_constants.dart';

class AnimeEntity {
	final String id;
	final String title;
	final String? synopsis;
	final String imageFileName;
	final int episodes;
	final double rating;
	final List<String> genres;
	final String status;
	final int? year;
	final String? studio;
	final DateTime createdAt;
	final DateTime? updatedAt;

	const AnimeEntity({
		required this.id,
		required this.title,
		this.synopsis,
		required this.imageFileName,
		required this.episodes,
		required this.rating,
		required this.genres,
		required this.status,
		this.year,
		this.studio,
		required this.createdAt,
		this.updatedAt,
	});

	/// Get cover image URL from imageFileName
	/// Supports:
	/// - Full public URL (https://...)
	/// - Web-session cache refs: web_image:filename
	/// - Local absolute file paths (mobile)
	/// - Supabase storage filenames/paths → converted to public URL
	String get coverImageUrl {
		if (imageFileName.isEmpty) {
			return ''; // Empty = no image, UI shows fallback icon
		}

		// Already a full public URL
		if (imageFileName.startsWith('http')) return imageFileName;

		// Web session cached reference (in-memory)
		if (imageFileName.startsWith('web_image:')) return imageFileName;

		// Local absolute path (mobile file system)
		if (imageFileName.contains('/') || imageFileName.contains('\\') || RegExp(r'^[A-Za-z]:').hasMatch(imageFileName)) {
			return imageFileName;
		}

		// Default or unknown → treat as Supabase storage path under bucket 'anime'
		// Example: 'anime_images/Screenshot 2026-01-31 084106.png'
		// Result: 'https://rzkrplsmetbbcuebysrg.supabase.co/storage/v1/object/public/anime/anime_images/Screenshot%202026-01-31%20084106.png'
		final bucket = 'anime';
		final encoded = Uri.encodeComponent(imageFileName);
		return '${ApiConstants.supabaseUrl}/storage/v1/object/public/$bucket/$encoded';
	}
}
