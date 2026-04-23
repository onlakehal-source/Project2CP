import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peeco/core/core.dart';
import 'package:peeco/client/client.dart';

class CompleteProfilePage extends StatefulWidget {
  final String prenom;
  final String nom;

  const CompleteProfilePage({
    super.key,
    required this.prenom,
    required this.nom,
  });

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? _pickedImage;
  bool _useInitials = false;

  String get _initials {
    final p = widget.prenom.isNotEmpty ? widget.prenom[0].toUpperCase() : '';
    final n = widget.nom.isNotEmpty ? widget.nom[0].toUpperCase() : '';
    return '$p$n';
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _useInitials = false;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _useInitials = false;
      });
    }
  }

  void _selectInitials() {
    setState(() {
      _pickedImage = null;
      _useInitials = true;
    });
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ClientHome()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Completez votre profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ajoutez une photo pour que\nles commerçants vous reconnaissent.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NotoLoopedThai',
                    fontSize: 16,
                    color: Color.fromARGB(187, 0, 0, 0),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 70),

                _Avatar(
                  image: _pickedImage,
                  useInitials: _useInitials,
                  initials: _initials,
                  size: 150,
                  backgroundColor: const Color.fromARGB(255, 210, 213, 178),
                ),
                const SizedBox(height: 90),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SourceButton(
                      icon: Icons.image_outlined,
                      label: 'Galerie',
                      onTap: _pickFromGallery,
                    ),
                    const SizedBox(width: 20),
                    _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Caméra',
                      onTap: _pickFromCamera,
                    ),
                    const SizedBox(width: 20),
                    _SourceButton(
                      customLabel: 'Aa',
                      label: 'Initiales',
                      onTap: _selectInitials,
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 176, 104),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _goToHome,
                  child: const Text(
                    'Passer cette étape',
                    style: TextStyle(
                      fontFamily: 'NotoLoopedThai',
                      fontSize: 17,
                      color: Color.fromARGB(199, 0, 0, 0),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final File? image;
  final bool useInitials;
  final String initials;
  final double size;
  final Color backgroundColor;

  const _Avatar({
    required this.image,
    required this.useInitials,
    required this.initials,
    this.size = 120,
    this.backgroundColor = const Color.fromARGB(255, 232, 228, 210),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _content(),
    );
  }

  Widget _content() {
    if (image != null) {
      return Image.file(image!, fit: BoxFit.cover);
    }
    if (useInitials) {
      return Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.normal,
            fontSize: 60,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
    }
    return Center(
      child: Image.asset(
        'assets/icon_person.png',
        width: size * 0.9,
        height: size * 0.9,
        fit: BoxFit.contain,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData? icon;
  final String? customLabel;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    this.icon,
    this.customLabel,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 213, 178),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: customLabel != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      customLabel!,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 24, color: Colors.black87),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'NotoLoopedThai',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
