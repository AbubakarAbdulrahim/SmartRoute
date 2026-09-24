import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  String? _profilePic;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user;
    _nameController = TextEditingController(text: user?.fullName);
    _profilePic = user?.profileImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(authNotifierProvider.notifier).updateProfile(
      name: _nameController.text,
      profilePic: _profilePic,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _profilePic = image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final user = state.user;

    return SrScreen(
      child: Column(
        children: [
          SrTopBar(
            title: 'Edit Profile',
            trailing: TextButton(
              onPressed: state.status == AuthStatus.loading ? null : _save,
              child: state.status == AuthStatus.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: SrColors.green),
                    )
                  : const Text('Save', style: TextStyle(color: SrColors.green, fontWeight: FontWeight.w800)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                Center(
                  child: Stack(
                    children: [
                      SrAvatar(size: 100, imageUrl: _profilePic),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: SrColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.camera, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('FULL NAME', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 8),
                SrCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('EMAIL ADDRESS', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 8),
                SrCard(
                  color: SrColors.panel.withValues(alpha: 0.4),
                  child: Text(user?.email ?? '', style: const TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 24),
                const Text('PHONE NUMBER', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 8),
                SrCard(
                   color: SrColors.panel.withValues(alpha: 0.4),
                  child: Text(user?.phoneNumber ?? 'Not provided', style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
