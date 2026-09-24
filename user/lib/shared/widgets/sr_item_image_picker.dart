import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'sr_ui.dart';

class SrItemImagePicker extends StatefulWidget {
  final Function(String?) onImagePicked;
  final String? initialImagePath;

  const SrItemImagePicker({
    super.key,
    required this.onImagePicked,
    this.initialImagePath,
  });

  @override
  State<SrItemImagePicker> createState() => _SrItemImagePickerState();
}

class _SrItemImagePickerState extends State<SrItemImagePicker> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _imagePath = image.path);
        widget.onImagePicked(image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Item Snapshot', style: TextStyle(color: SrColors.muted, fontSize: 12)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: SrColors.panel,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(LucideIcons.camera, color: SrColors.green),
                      title: const Text('Take a Photo'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.image, color: SrColors.green),
                      title: const Text('Choose from Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: SrColors.panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SrColors.line),
            ),
            child: _imagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.camera, color: SrColors.muted, size: 32),
                      const SizedBox(height: 8),
                      const Text('Snap the item', style: TextStyle(color: SrColors.muted, fontSize: 13)),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      SrImage(
                        imageUrl: _imagePath,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _imagePath = null);
                            widget.onImagePicked(null);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(LucideIcons.x, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
