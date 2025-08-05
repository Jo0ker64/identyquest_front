import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingPassword = false;
  File? _profileImage; // stockage local temporaire

  static const double _radius = 8;
  static const EdgeInsets _hPad = EdgeInsets.symmetric(horizontal: 24);

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // 🔹 Ici tu pourrais sauvegarder l'image dans Hive, SharedPreferences ou l'envoyer à ton backend
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/user-home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Avatar avec image sélectionnée
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 48, color: Colors.white)
                          : null,
                    ),
                    TextButton(
                      onPressed: _pickProfileImage,
                      child: const Text("Modifier l’image"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Champs profil
              Padding(
                padding: _hPad,
                child: Column(
                  children: [
                    _buildNonEditableField('Pseudo'),
                    const SizedBox(height: 12),
                    _buildEditableField('E-mail'),
                    const SizedBox(height: 12),
                    if (isEditingPassword) ...[
                      _buildEditableField('Nouveau mot de passe', obscure: true),
                      const SizedBox(height: 12),
                      _buildEditableField('Confirmer mot de passe', obscure: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => isEditingPassword = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.softBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                          ),
                          child: const Text('Valider le mot de passe'),
                        ),
                      ),
                    ] else
                      _buildEditableField(
                        'Mot de passe',
                        obscure: true,
                        onEdit: () => setState(() => isEditingPassword = true),
                      ),
                    const SizedBox(height: 12),
                    _buildEditableField('Ville'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Enregistrer
              Padding(
                padding: _hPad,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Sauvegarde profil + image si modifiée
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Enregistrer les changements'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_radius),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔴 Actions secondaires
              Padding(
                padding: _hPad,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_radius),
                          ),
                        ),
                        child: const Text('Déconnexion'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_radius),
                          ),
                        ),
                        child: const Text('Supprimer mon compte'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String hint, {bool obscure = false, VoidCallback? onEdit}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_radius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Modifier',
          ),
      ],
    );
  }

  Widget _buildNonEditableField(String hint) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
