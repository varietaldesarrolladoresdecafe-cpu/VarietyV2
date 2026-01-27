import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodels/brew_gpt_viewmodel.dart';
import 'user_profile_setup_page.dart';

class BrewGPTChatPage extends StatefulWidget {
  const BrewGPTChatPage({super.key});

  @override
  State<BrewGPTChatPage> createState() => _BrewGPTChatPageState();
}

class _BrewGPTChatPageState extends State<BrewGPTChatPage> {
  late TextEditingController _methodController;
  late TextEditingController _coffeeInfoController;
  late TextEditingController _problemController;
  late TextEditingController _sensoryController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _methodController = TextEditingController();
    _coffeeInfoController = TextEditingController();
    _problemController = TextEditingController();
    _sensoryController = TextEditingController();
    
    // Cargar perfil del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrewGPTViewModel>().loadUserProfile();
    });
  }

  @override
  void dispose() {
    _methodController.dispose();
    _coffeeInfoController.dispose();
    _problemController.dispose();
    _sensoryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _askBrewGPT() {
    final viewModel = context.read<BrewGPTViewModel>();
    
    if (_methodController.text.isEmpty || _problemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa método y problema')),
      );
      return;
    }

    viewModel.askBrewGPT(
      method: _methodController.text,
      coffeeInfo: _coffeeInfoController.text,
      lastRecipe: {},
      problem: _problemController.text,
      sensoryAnalysis: _sensoryController.text,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'BREW GPT ☕',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 14,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              'Tu asistente en café de especialidad',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                fontSize: 9,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Consumer<BrewGPTViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: const Icon(Icons.person, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileSetupPage(isEditing: true),
                    ),
                  ).then((_) {
                    // Recargar perfil después de editar
                    viewModel.loadUserProfile();
                  });
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<BrewGPTViewModel>(
              builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome message
                        FadeInDown(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Hola${viewModel.userProfile != null && viewModel.userProfile!.name.isNotEmpty ? ', ${viewModel.userProfile!.name}' : ''}! ☕',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Soy tu asistente especializado en café de especialidad. Cuéntame sobre tu método de extracción, el café que estás preparando, y si hay algo que no te esté saliendo bien. ¡Juntos mejoraremos tu taza! 🎯',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Input fields
                        _buildInputField(
                          label: 'Método de extracción',
                          hint:
                              'Ej: V60, Aeropress, Espresso, Pour over, Moka',
                          controller: _methodController,
                          icon: Icons.coffee,
                        ),
                        const SizedBox(height: 16),

                        _buildInputField(
                          label: 'Información del café',
                          hint:
                              'Ej: Etiopía, Geisha, tostado claro, 12 días de reposo',
                          controller: _coffeeInfoController,
                          icon: Icons.info_outline,
                        ),
                        const SizedBox(height: 16),

                        _buildInputField(
                          label: 'Problema o ajuste deseado',
                          hint:
                              'Ej: El café está muy ácido, Quiero más cuerpo, Está amargo',
                          controller: _problemController,
                          icon: Icons.warning,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        _buildInputField(
                          label: 'Análisis sensorial (opcional)',
                          hint:
                              'Ej: Notas florales, chocolate amargo, afrutado',
                          controller: _sensoryController,
                          icon: Icons.palette,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),

                        // Response
                        if (viewModel.isLoading) ...[
                          Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'BrewGPT está pensando...',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (viewModel.error != null) ...[
                          FadeInUp(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Error',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    viewModel.error!,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.red.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else if (viewModel.advice != null) ...[
                          FadeInUp(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.secondary.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Consejo de BrewGPT',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        viewModel.advice!.content,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Acciones recomendadas:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...viewModel.advice!.actionItems
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final action = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 2),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            action,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: AppColors.textPrimary
                                                  .withValues(alpha: 0.8),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Send button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _askBrewGPT,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'PEDIR CONSEJO A BREWGPT',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.textPrimary.withValues(alpha: 0.3),
            ),
            prefixIcon: Icon(icon, color: AppColors.secondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}


