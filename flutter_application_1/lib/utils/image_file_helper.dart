import 'package:flutter/widgets.dart';

// Stub implementation for platforms where dart:io is not available (web).
// Returns null so callers can fallback to other ImageProviders.
ImageProvider<Object>? fileImageProvider(String path) {
  return null;
}
