import 'dart:io';
import 'package:flutter/widgets.dart';

// Real implementation for platforms that support dart:io (mobile/desktop).
ImageProvider<Object>? fileImageProvider(String path) {
  try {
    final file = File(path);
    return FileImage(file);
  } catch (_) {
    return null;
  }
}
