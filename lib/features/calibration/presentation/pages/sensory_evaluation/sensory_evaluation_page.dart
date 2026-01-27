import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/coffee_session_data.dart';
import '../../../domain/models/coffee_sample.dart';

class SensoryEvaluationPage extends StatefulWidget {
  final CoffeeSessionData sessionData;

  const SensoryEvaluationPage({
    super.key,
    required this.sessionData,
  });

  @override
  State<SensoryEvaluationPage> createState() => _SensoryEvaluationPageState();
}

class _SensoryEvaluationPageState extends State<SensoryEvaluationPage>
    with SingleTickerProviderStateMixin {
  late List<CoffeeSample> samples;
  late int currentSampleIndex;
  late AnimationController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeSamples();
  }

  void _initializeSamples() {
    samples = List.generate(
      widget.sessionData.sampleCount,
      (index) => CoffeeSample.empty(index + 1),
    );
    currentSampleIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCurrentSample(CoffeeSample updatedSample) {
    setState(() {
      samples[currentSampleIndex] = updatedSample;
    });
  }

  void _nextSample() {
    if (currentSampleIndex < samples.length - 1) {
      _pageController.forward(from: 0);
      setState(() => currentSampleIndex++);
    }
  }

  void _previousSample() {
    if (currentSampleIndex > 0) {
      _pageController.reverse(from: 1);
      setState(() => currentSampleIndex--);
    }
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
              'SENSORY EVALUATION',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 14,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              widget.sessionData.brandName,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Sample Name Section
                  if (widget.sessionData.sampleCount > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildSampleNameSection(),
                    ),

                  // Evaluation Content
                  _buildEvaluationContent(),

                  const SizedBox(height: 30),

                  // Navigation Buttons
                  if (widget.sessionData.sampleCount > 1)
                    _buildSampleNavigation(),

                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.sessionData.sampleCount > 1
                            ? (currentSampleIndex == samples.length - 1
                                ? 'FINALIZAR EVALUACIÓN'
                                : 'GUARDAR Y CONTINUAR')
                            : 'GUARDAR EVALUACIÓN',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSampleNameSection() {
    final currentSample = samples[currentSampleIndex];
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.background,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentSample.sampleName,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showEditSampleNameDialog(currentSample),
              child: Icon(Icons.edit, color: AppColors.secondary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSampleNameDialog(CoffeeSample sample) {
    final controller = TextEditingController(text: sample.sampleName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Editar nombre de la muestra',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          style: GoogleFonts.montserrat(color: AppColors.textPrimary),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.secondary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.montserrat(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              final updatedSample =
                  sample.copyWith(sampleName: controller.text);
              _updateCurrentSample(updatedSample);
              Navigator.pop(context);
            },
            child: Text(
              'Guardar',
              style: GoogleFonts.montserrat(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationContent() {
    final currentSample = samples[currentSampleIndex];
    return FadeInUp(
      child: Column(
        children: [
          _SensorySectionWidget(
            title: 'FRAGANCIA',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['fragancia']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {...currentSample.sliderValues, 'fragancia': value},
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesFragancia,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesFragancia: value);
              _updateCurrentSample(updated);
            },
            selectedTags: currentSample.selectedAromaTags,
            onTagSelected: (tag) {
              final newTags = Set<String>.from(currentSample.selectedAromaTags);
              if (newTags.contains(tag)) {
                newTags.remove(tag);
              } else {
                newTags.add(tag);
              }
              final updated = currentSample.copyWith(selectedAromaTags: newTags);
              _updateCurrentSample(updated);
            },
            availableTags: const [
              'FLORAL',
              'AFRUTADO',
              'BAYAS',
              'TOSTADO',
              'CEREAL',
              'QUEMADO'
            ],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'AROMA',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['aroma']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {...currentSample.sliderValues, 'aroma': value},
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesAroma,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesAroma: value);
              _updateCurrentSample(updated);
            },
            selectedTags: currentSample.selectedFlavorTags,
            onTagSelected: (tag) {
              final newTags = Set<String>.from(currentSample.selectedFlavorTags);
              if (newTags.contains(tag)) {
                newTags.remove(tag);
              } else {
                newTags.add(tag);
              }
              final updated = currentSample.copyWith(selectedFlavorTags: newTags);
              _updateCurrentSample(updated);
            },
            availableTags: const [
              'FRUTAS DESHIDRATADAS',
              'CÍTRICOS',
              'TABACO',
              'ESPECIAS',
              'DULCE'
            ],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'SABOR',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['sabor']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {...currentSample.sliderValues, 'sabor': value},
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesSabor,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesSabor: value);
              _updateCurrentSample(updated);
            },
            selectedTags: currentSample.selectedBasicTasteTags,
            onTagSelected: (tag) {
              final newTags =
                  Set<String>.from(currentSample.selectedBasicTasteTags);
              if (newTags.contains(tag)) {
                newTags.remove(tag);
              } else {
                newTags.add(tag);
              }
              final updated =
                  currentSample.copyWith(selectedBasicTasteTags: newTags);
              _updateCurrentSample(updated);
            },
            availableTags: const [
              'SALADO',
              'AMARGO',
              'ÁCIDO',
              'UMAMI',
              'DULCE',
              'NUECES/CACAO'
            ],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'SABOR RESIDUAL',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['sabor_residual']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {
                  ...currentSample.sliderValues,
                  'sabor_residual': value
                },
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesSaborResidual,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesSaborResidual: value);
              _updateCurrentSample(updated);
            },
            selectedTags: currentSample.selectedAftertasteTags,
            onTagSelected: (tag) {
              final newTags =
                  Set<String>.from(currentSample.selectedAftertasteTags);
              if (newTags.contains(tag)) {
                newTags.remove(tag);
              } else {
                newTags.add(tag);
              }
              final updated =
                  currentSample.copyWith(selectedAftertasteTags: newTags);
              _updateCurrentSample(updated);
            },
            availableTags: const ['SALADO', 'AMARGO', 'ÁCIDO'],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'ACIDEZ',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['acidez']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {...currentSample.sliderValues, 'acidez': value},
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesAcidez,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesAcidez: value);
              _updateCurrentSample(updated);
            },
            selectedTags: {},
            onTagSelected: (_) {},
            availableTags: const [],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'DULZOR',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['dulzor']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {...currentSample.sliderValues, 'dulzor': value},
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesDulzor,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesDulzor: value);
              _updateCurrentSample(updated);
            },
            selectedTags: {},
            onTagSelected: (_) {},
            availableTags: const [],
          ),
          const SizedBox(height: 30),
          _SensorySectionWidget(
            title: 'SENSACIÓN EN BOCA',
            intensity: 'INTENSIDAD',
            sliderValue: currentSample.sliderValues['sensacion_boca']!,
            onSliderChanged: (value) {
              final updated = currentSample.copyWith(
                sliderValues: {
                  ...currentSample.sliderValues,
                  'sensacion_boca': value
                },
              );
              _updateCurrentSample(updated);
            },
            notes: currentSample.notesSensacionBoca,
            onNotesChanged: (value) {
              final updated = currentSample.copyWith(notesSensacionBoca: value);
              _updateCurrentSample(updated);
            },
            selectedTags: currentSample.selectedMouthFeelTags,
            onTagSelected: (tag) {
              final newTags =
                  Set<String>.from(currentSample.selectedMouthFeelTags);
              if (newTags.contains(tag)) {
                newTags.remove(tag);
              } else {
                newTags.add(tag);
              }
              final updated =
                  currentSample.copyWith(selectedMouthFeelTags: newTags);
              _updateCurrentSample(updated);
            },
            availableTags: const [
              'ÁSPERO',
              'SUAVE',
              'METÁLICO',
              'ACEITOSO',
              'DEJA SECA LA BOCA'
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSampleNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: currentSampleIndex > 0 ? _previousSample : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentSampleIndex > 0
                  ? AppColors.secondary
                  : AppColors.secondary.withValues(alpha: 0.3),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentSampleIndex + 1}/${samples.length}',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed:
                currentSampleIndex < samples.length - 1 ? _nextSample : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentSampleIndex < samples.length - 1
                  ? AppColors.secondary
                  : AppColors.secondary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEvaluation() {
    // TODO: Implement save evaluation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.sessionData.sampleCount > 1
              ? (currentSampleIndex == samples.length - 1
                  ? 'Evaluación finalizada'
                  : 'Muestra guardada')
              : 'Evaluación guardada correctamente',
        ),
        backgroundColor: AppColors.secondary,
      ),
    );

    if (currentSampleIndex < samples.length - 1) {
      _nextSample();
    } else {
      Navigator.pop(context);
    }
  }
}

class _SensorySectionWidget extends StatelessWidget {
  final String title;
  final String intensity;
  final double sliderValue;
  final Function(double) onSliderChanged;
  final String notes;
  final Function(String) onNotesChanged;
  final Set<String> selectedTags;
  final Function(String) onTagSelected;
  final List<String> availableTags;

  const _SensorySectionWidget({
    required this.title,
    required this.intensity,
    required this.sliderValue,
    required this.onSliderChanged,
    required this.notes,
    required this.onNotesChanged,
    required this.selectedTags,
    required this.onTagSelected,
    required this.availableTags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          intensity,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        // Slider with value display - DIVISIONS OF 0.25
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    elevation: 4,
                    enabledThumbRadius: 9,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: 10,
                  divisions: 40, // 0-10 with 0.25 steps = 40 divisions
                  onChanged: (value) {
                    // Round to nearest 0.25
                    final rounded = (value * 4).round() / 4;
                    onSliderChanged(rounded);
                  },
                  activeColor: AppColors.secondary,
                  inactiveColor: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sliderValue.toStringAsFixed(2),
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: onNotesChanged,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Notas...',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.textPrimary.withValues(alpha: 0.3),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: AppColors.background,
          ),
          maxLines: 2,
        ),
        if (availableTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: availableTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) => onTagSelected(tag),
                backgroundColor: Colors.transparent,
                selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                labelStyle: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.textPrimary.withValues(alpha: 0.5),
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.textPrimary.withValues(alpha: 0.15),
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}


