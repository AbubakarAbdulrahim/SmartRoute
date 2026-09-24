import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cloudinary_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService(CloudinaryService()));

class StorageService {
  final CloudinaryService _cloudinary;
  StorageService(this._cloudinary);

  Future<String> uploadFile(String path, File file) async {
    return await _cloudinary.uploadImage(file);
  }

  Future<void> deleteFile(String url) async {
    await _cloudinary.deleteImage(url);
  }
}
