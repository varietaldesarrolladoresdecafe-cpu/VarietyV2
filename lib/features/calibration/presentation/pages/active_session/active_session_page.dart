import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:variety_coffee_developers/features/calibration/presentation/viewmodels/active_session_viewmodel.dart';
import 'package:variety_coffee_developers/features/calibration/domain/entities/calibration_method.dart';
import 'package:variety_coffee_developers/features/brew_gpt/presentation/pages/brew_gpt_chat_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:variety_coffee_developers/core/theme/app_colors.dart';

class ActiveSessionPage extends StatelessWidget {
  final CalibrationMethod method;
  final Map<String, dynamic> sessionInfo; // Datos del setup anterior
  final bool isAdvanced; // True para avanzado, False para básico

  const ActiveSessionPage({
    super.key,
    required this.method,
    required this.sessionInfo,
    this.isAdvanced = false,
  });

  void _saveSession(BuildContext context) {
    final viewModel = context.read<ActiveSessionViewModel>();
    viewModel.saveRecipe();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión guardada correctamente'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate back and potentially show BrewGPT recommendation
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActiveSessionViewModel(method: method)..setSessionInfo(sessionInfo),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'CALIBRATION SESSION',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 1.0,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _saveSession(context),
            )
          ],
        ),
        body: _RecipeForm(isAdvanced: isAdvanced, sessionInfo: sessionInfo),
        floatingActionButton: _BrewGPTButton(sessionInfo: sessionInfo),
      ),
    );
  }
}

class _RecipeForm extends StatefulWidget {
  final bool isAdvanced;
  final Map<String, dynamic> sessionInfo;
  
  const _RecipeForm({
    required this.isAdvanced,
    required this.sessionInfo,
  });

  @override
  State<_RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<_RecipeForm> {
  final _doseController = TextEditingController();
  final _yieldController = TextEditingController();
  final _grindController = TextEditingController();
  final _timeController = TextEditingController();
  final _sensoryController = TextEditingController();
  final _problemController = TextEditingController();
  
  // Advanced fields
  final _preInfusionTimeController = TextEditingController();
  final _preInfusionPressureController = TextEditingController();
  final _shotTimeController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _observationsController = TextEditingController();

  @override
  void dispose() {
    _doseController.dispose();
    _yieldController.dispose();
    _grindController.dispose();
    _timeController.dispose();
    _sensoryController.dispose();
    _problemController.dispose();
    _preInfusionTimeController.dispose();
    _preInfusionPressureController.dispose();
    _shotTimeController.dispose();
    _temperatureController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ActiveSessionViewModel>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Session Info Header
        if (widget.sessionInfo.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SESSION INFO',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.sessionInfo['variety'] != null)
                  Text('☕ ${widget.sessionInfo['variety']}', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
                if (widget.sessionInfo['espresso_machine'] != null)
                  Text('🖥️ ${widget.sessionInfo['espresso_machine']}', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
                if (widget.sessionInfo['grinder'] != null)
                  Text('⚙️ ${widget.sessionInfo['grinder']}', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
                if (widget.sessionInfo['days'] != null)
                  Text('📅 ${widget.sessionInfo['days']} days off roast', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Historial de recetas previas
        if (viewModel.recipes.isNotEmpty) ...[
          Text(
            'Previous Iterations: ${viewModel.recipes.length}',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.recipes.length,
              itemBuilder: (context, index) {
                final recipe = viewModel.recipes[index];
                return Card(
                  color: AppColors.cardEspresso.withValues(alpha: 0.2),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Iteration #${index + 1}',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (recipe['dose'] != null)
                          Text('Dose: ${recipe['dose']}g', style: const TextStyle(fontSize: 12)),
                        if (recipe['yield'] != null)
                          Text('Yield: ${recipe['yield']}g', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 32),
        ],

        Text(
          'NEW RECIPE',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        // Basic Fields
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _doseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dose (g)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (val) => viewModel.updateField('dose', double.tryParse(val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _yieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Yield (g/ml)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (val) => viewModel.updateField('yield', double.tryParse(val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _grindController,
          decoration: InputDecoration(
            labelText: 'Grind Setting',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) => viewModel.updateField('grind', val),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _timeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Total Time (seconds)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) => viewModel.updateField('time', val),
        ),
        const SizedBox(height: 24),

        // Advanced Fields
        if (widget.isAdvanced) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADVANCED PARAMETERS',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _preInfusionTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pre-Infusion Time (s)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (val) => viewModel.updateField('preInfusionTime', double.tryParse(val)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _preInfusionPressureController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pre-Infusion Pressure (bar)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (val) => viewModel.updateField('preInfusionPressure', double.tryParse(val)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _shotTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Shot Time (s)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (val) => viewModel.updateField('shotTime', double.tryParse(val)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _temperatureController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Temperature (°C)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (val) => viewModel.updateField('temperature', double.tryParse(val)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observationsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Observations & Notes',
                    hintText: 'Describe flow, resistance, sound...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (val) => viewModel.updateField('observations', val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Sensory Analysis
        Text(
          'SENSORY ANALYSIS',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _sensoryController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Tasting Notes',
            hintText: 'Acid, Bitter, Sweet, Body...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) => viewModel.updateField('sensory', val),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _problemController,
          decoration: InputDecoration(
            labelText: 'Main Issue',
            hintText: 'Too sour, dry finish, bitter...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) => viewModel.updateField('problem', val),
        ),

        const SizedBox(height: 24),
        SizedBox(
          height: 60,
          child: FilledButton(
            onPressed: () {
              viewModel.saveRecipe();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recipe saved!')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cardEspresso,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check),
                const SizedBox(width: 8),
                Text(
                  'SAVE ITERATION',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _BrewGPTButton extends StatelessWidget {
  final Map<String, dynamic> sessionInfo;
  
  const _BrewGPTButton({required this.sessionInfo});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveSessionViewModel>(
      builder: (context, viewModel, _) {
        return FloatingActionButton.extended(
          onPressed: () {
            // Get the last saved recipe to pass to BrewGPT
            final lastRecipe = viewModel.getLastRecipe();
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrewGPTChatPage(
                  recipeToAnalyze: lastRecipe,
                ),
              ),
            );
          },
          backgroundColor: AppColors.secondary,
          elevation: 6,
          icon: const Icon(Icons.smart_toy, color: Colors.white),
          label: Text(
            'Ask BrewGPT',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// Keep the old modal for reference (can be removed if not used elsewhere)
class BrewGPTChatModal extends StatelessWidget {
  final Map<String, dynamic> sessionInfo;
  
  const BrewGPTChatModal({required this.sessionInfo});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        color: AppColors.background,
        child: const Center(
          child: Text('BrewGPT Modal'),
        ),
      ),
    );
  }
}