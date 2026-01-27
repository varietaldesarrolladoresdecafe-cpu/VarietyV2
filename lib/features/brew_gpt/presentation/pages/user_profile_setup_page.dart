import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../viewmodels/brew_gpt_viewmodel.dart';

class UserProfileSetupPage extends StatefulWidget {
  final bool isEditing;

  const UserProfileSetupPage({super.key, this.isEditing = false});

  @override
  State<UserProfileSetupPage> createState() => _UserProfileSetupPageState();
}

class _UserProfileSetupPageState extends State<UserProfileSetupPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _methodController;

  SkillLevel _selectedSkillLevel = SkillLevel.beginner;
  WaterType _selectedWaterType = WaterType.filtered;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _methodController = TextEditingController();

    // Cargar datos existentes si existe perfil
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<BrewGPTViewModel>();
      final profile = viewModel.userProfile;

      if (profile != null && profile.id.isNotEmpty) {
        _nameController.text = profile.name;
        _locationController.text = profile.location;
        _methodController.text = profile.favoriteMethod;
        _selectedSkillLevel = profile.skillLevel;
        _selectedWaterType = profile.waterType;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _methodController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre')),
      );
      return;
    }

    final viewModel = context.read<BrewGPTViewModel>();
    final profile = UserProfile(
      id: viewModel.userProfile?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      skillLevel: _selectedSkillLevel,
      favoriteMethod: _methodController.text,
      location: _locationController.text,
      waterType: _selectedWaterType,
      createdAt: viewModel.userProfile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await viewModel.updateUserProfile(profile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Perfil guardado con éxito')),
      );

      if (!widget.isEditing) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          widget.isEditing ? 'Editar Perfil' : 'Tu Perfil de Café',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<BrewGPTViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FadeInUp(
                    child: Text(
                      'Ayúdanos a conocerte mejor',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: _buildTextField(
                      controller: _nameController,
                      label: 'Tu Nombre',
                      icon: Icons.person,
                      hint: 'Ej: María',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildDropdown<SkillLevel>(
                      label: 'Nivel de Experiencia',
                      value: _selectedSkillLevel,
                      items: SkillLevel.values,
                      itemLabel: (level) {
                        switch (level) {
                          case SkillLevel.beginner:
                            return '🌱 Principiante';
                          case SkillLevel.intermediate:
                            return '☕ Intermedio';
                          case SkillLevel.advanced:
                            return '🏆 Avanzado';
                        }
                      },
                      onChanged: (value) {
                        setState(() => _selectedSkillLevel = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildTextField(
                      controller: _methodController,
                      label: 'Método Favorito',
                      icon: Icons.local_cafe,
                      hint: 'Ej: V60, Espresso, Aeropress',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildTextField(
                      controller: _locationController,
                      label: 'Tu Ubicación',
                      icon: Icons.location_on,
                      hint: 'Ej: Buenos Aires, Argentina',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: _buildDropdown<WaterType>(
                      label: 'Tipo de Agua',
                      value: _selectedWaterType,
                      items: WaterType.values,
                      itemLabel: (type) {
                        switch (type) {
                          case WaterType.tap:
                            return '💧 Del Grifo';
                          case WaterType.filtered:
                            return '🚿 Filtrada';
                          case WaterType.distilled:
                            return '🧪 Destilada';
                          case WaterType.bottled:
                            return '🫙 Embotellada';
                          case WaterType.mineral:
                            return '⛏️ Mineral';
                        }
                      },
                      onChanged: (value) {
                        setState(() => _selectedWaterType = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Guardar Perfil',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            underline: const SizedBox(),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(itemLabel(item)),
                    ))
                .toList(),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
