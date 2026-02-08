import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/features/anime/data/models/anime_model.dart';
import 'package:flutter_application_1/features/anime/presentation/providers/anime_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Global image cache for web platform - PUBLIC so other widgets can access it
Map<String, Uint8List> webImageCache = {};

class AnimeFormModal extends ConsumerStatefulWidget {
  final AnimeModel? anime;
  final VoidCallback onSuccess;

  const AnimeFormModal({
    super.key,
    this.anime,
    required this.onSuccess,
  });

  @override
  ConsumerState<AnimeFormModal> createState() => _AnimeFormModalState();
}

class _AnimeFormModalState extends ConsumerState<AnimeFormModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _synopsisController;
  late final TextEditingController _studioController;
  late final TextEditingController _yearController;
  late final TextEditingController _episodesController;
  late final TextEditingController _genresController;

  String _selectedStatus = 'Upcoming';
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes; // for web preview
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.anime?.title ?? '');
    _synopsisController = TextEditingController(text: widget.anime?.synopsis ?? '');
    _studioController = TextEditingController(text: widget.anime?.studio ?? '');
    _yearController = TextEditingController(text: widget.anime?.year.toString() ?? '');
    _episodesController = TextEditingController(text: widget.anime?.episodes.toString() ?? '');
    _genresController = TextEditingController(text: widget.anime?.genres.join(', ') ?? '');
    _selectedStatus = widget.anime?.status ?? 'Upcoming';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _studioController.dispose();
    _yearController.dispose();
    _episodesController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.anime == null ? 'Add New Anime' : 'Edit Anime',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 24),

              _buildTextField(controller: _titleController, label: 'Title *', hint: 'e.g., Frieren: Beyond Journey\'s End'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(controller: _yearController, label: 'Year *', hint: '2024', keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(controller: _episodesController, label: 'Episodes *', hint: '12', keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildStatusDropdown(),
              const SizedBox(height: 16),

              _buildTextField(controller: _studioController, label: 'Studio', hint: 'e.g., Madhouse'),
              const SizedBox(height: 16),

              _buildTextField(controller: _genresController, label: 'Genres', hint: 'e.g., Adventure, Drama, Fantasy (comma separated)', maxLines: 2),
              const SizedBox(height: 16),

              _buildImageUploadSection(),
              const SizedBox(height: 16),

              _buildTextField(controller: _synopsisController, label: 'Synopsis', hint: 'Brief description of the anime', maxLines: 4),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: _isLoading ? null : () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _isLoading ? null : _submitForm, child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(widget.anime == null ? 'Add Anime' : 'Update Anime')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(controller: controller, keyboardType: keyboardType, maxLines: maxLines, decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.all(12))),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status *', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          items: ['Ongoing', 'Completed', 'Upcoming'].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
          onChanged: (value) => setState(() => _selectedStatus = value ?? 'Upcoming'),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty || _yearController.text.isEmpty || _episodesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('[DEBUG] Submitting form for: ${_titleController.text}');
      final repository = ref.read(animeRepositoryProvider);
      final genres = _genresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      String imageFileName = '';
      print('[DEBUG] Initial image file name: $imageFileName');
      print('[DEBUG] Image selected: $_selectedImage, ImageBytes: $_selectedImageBytes');
      
      if (kIsWeb && _selectedImageBytes != null) {
        // On web, cache the bytes and store a web reference
        print('[DEBUG] Web: Saving image bytes...');
        final saved = await _saveImageToAssets(_titleController.text);
        if (saved != null) {
          imageFileName = saved; // keep the web reference (web_image:filename)
          print('[DEBUG] Web: Image saved as: $imageFileName');
        }
      } else if (!kIsWeb && _selectedImage != null) {
        // On mobile, save the file and store absolute path
        print('[DEBUG] Mobile: Saving image file...');
        final saved = await _saveImageToAssets(_titleController.text);
        if (saved != null) {
          imageFileName = saved; // saved is absolute filepath
          print('[DEBUG] Mobile: Image saved as: $imageFileName');
        }
      }

      print('[DEBUG] Final image file name to save: $imageFileName');

      if (widget.anime == null) {
        print('[DEBUG] Creating new anime...');
        await repository.createAnime(
          title: _titleController.text,
          synopsis: _synopsisController.text,
          studio: _studioController.text,
          year: int.parse(_yearController.text),
          episodes: int.parse(_episodesController.text),
          rating: 0.0,
          genres: genres,
          status: _selectedStatus,
          imageFileName: imageFileName,
        );
        print('[DEBUG] Anime created successfully');
      } else {
        print('[DEBUG] Updating anime...');
        final updated = widget.anime!.copyWith(
          title: _titleController.text,
          synopsis: _synopsisController.text,
          studio: _studioController.text,
          year: int.parse(_yearController.text),
          episodes: int.parse(_episodesController.text),
          genres: genres,
          status: _selectedStatus,
          imageFileName: _selectedImage != null ? imageFileName : widget.anime!.imageFileName,
        );
        await repository.updateAnime(updated);
        print('[DEBUG] Anime updated successfully');
      }

      if (mounted) widget.onSuccess();
    } catch (e) {
      print('[DEBUG] Error in _submitForm: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anime Poster', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (kIsWeb && _selectedImageBytes != null)
          Stack(children: [
            Container(height: 150, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover))),
            Positioned(top: 4, right: 4, child: GestureDetector(onTap: () => setState(() => _selectedImageBytes = null), child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.close, color: Colors.white, size: 16)))),
          ])
        else if (!kIsWeb && _selectedImage != null)
          Stack(children: [
            Container(height: 150, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover))),
            Positioned(top: 4, right: 4, child: GestureDetector(onTap: () => setState(() => _selectedImage = null), child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.close, color: Colors.white, size: 16)))),
          ])
        else
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(border: Border.all(color: AppColors.border, style: BorderStyle.solid), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_outlined, color: AppColors.textHint, size: 32), const SizedBox(height: 8), Text('Click to select image', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint))])),
        const SizedBox(height: 8),
        ElevatedButton.icon(onPressed: _isLoading ? null : _pickImage, icon: const Icon(Icons.image_search), label: const Text('Select Image')),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      print('[DEBUG] Starting image pick...');
      if (kIsWeb) {
        print('[DEBUG] Web platform detected');
        final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
        if (result == null || result.files.isEmpty) {
          print('[DEBUG] No file selected on web');
          return;
        }
        final file = result.files.first;
        print('[DEBUG] File selected: ${file.name}, Size: ${file.size} bytes');
        if (file.bytes != null) {
          setState(() {
            _selectedImageBytes = file.bytes;
            _selectedImageName = file.name;
          });
          print('[DEBUG] Image loaded for web: ${file.name}');
        }
      } else {
        print('[DEBUG] Mobile platform detected');
        final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
        if (image != null) {
          print('[DEBUG] Image picked: ${image.name}, Path: ${image.path}');
          setState(() => _selectedImage = image);
        } else {
          print('[DEBUG] No image selected on mobile');
        }
      }
    } catch (e) {
      print('[DEBUG] Error picking image: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e'), backgroundColor: AppColors.error));
    }
  }

  Future<String?> _saveImageToAssets(String animeName) async {
    // On web we cannot write to device filesystem in the same way.
    if (kIsWeb) {
      if (_selectedImageBytes == null && _selectedImageName == null) {
        print('[DEBUG] Web: No image bytes or name found');
        return null;
      }
      
      final filename = _selectedImageName ?? 'web_image_${DateTime.now().millisecondsSinceEpoch}';
      print('[DEBUG] Web: Attempting upload to Supabase for: $filename, Size: ${_selectedImageBytes?.length} bytes');
      try {
        final supabase = Supabase.instance.client;
        const bucket = 'anime';
        final storagePath = 'anime_images/$filename';
        // Try upload bytes to Supabase Storage (web)
        await supabase.storage.from(bucket).uploadBinary(storagePath, _selectedImageBytes!);
        final publicUrl = supabase.storage.from(bucket).getPublicUrl(storagePath);
        if (publicUrl != null && publicUrl.isNotEmpty) {
          print('[DEBUG] Supabase upload (web) succeeded. Public URL: $publicUrl');
          return publicUrl;
        }
      } catch (e) {
        print('[DEBUG] Supabase upload (web) failed: $e');
      }

      // Fallback: store in memory cache so it shows immediately in this session
      print('[DEBUG] Web: Caching image bytes for session fallback: $filename');
      if (_selectedImageBytes != null) {
        webImageCache[filename] = _selectedImageBytes!;
        print('[DEBUG] Web: Image cached successfully. Cache size now: ${webImageCache.length} items');
      }

      final result = 'web_image:$filename';
      print('[DEBUG] Web: Returning image reference: $result');
      return result;
    }

    if (_selectedImage == null) {
      print('[DEBUG] Mobile: No selected image');
      return null;
    }
    try {
      print('[DEBUG] Mobile: Starting image save...');
      final directory = await getApplicationDocumentsDirectory();
      print('[DEBUG] Documents directory: ${directory.path}');
      // Save to app documents directory instead of trying to write to project assets
      final appDir = Directory('${directory.path}/anime_images');
      print('[DEBUG] Target anime images dir: ${appDir.path}');
      
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
        print('[DEBUG] Created anime_images directory');
      }
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = "${animeName.replaceAll(' ', '_')}_$timestamp${path.extension(_selectedImage!.path)}";
      final filepath = '${appDir.path}/$filename';
      print('[DEBUG] Source file: ${_selectedImage!.path}');
      print('[DEBUG] Target file: $filepath');
      print('[DEBUG] Filename: $filename');

      await File(_selectedImage!.path).copy(filepath);
      print('[DEBUG] File copied successfully');
      // Try upload to Supabase Storage for persistence
      try {
        final supabase = Supabase.instance.client;
        const bucket = 'anime';
        final storagePath = 'anime_images/$filename';
        final fileForUpload = File(filepath);
        await supabase.storage.from(bucket).upload(storagePath, fileForUpload);
        final publicUrl = supabase.storage.from(bucket).getPublicUrl(storagePath);
        if (publicUrl != null && publicUrl.isNotEmpty) {
          print('[DEBUG] Supabase upload (mobile) succeeded. Public URL: $publicUrl');
          return publicUrl;
        }
      } catch (e) {
        print('[DEBUG] Supabase upload (mobile) failed: $e');
      }

      // Return absolute filepath if upload failed
      final saved = filepath;
      print('[DEBUG] Returning absolute path: $saved');
      return saved;
    } catch (e) {
      print('[DEBUG] Error saving image: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving image: $e'), backgroundColor: AppColors.error));
      return null;
    }
  }
}
