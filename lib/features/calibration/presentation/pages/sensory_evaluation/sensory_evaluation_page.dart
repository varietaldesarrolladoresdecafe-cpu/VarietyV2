import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SensoryEvaluationPage extends StatefulWidget {
  const SensoryEvaluationPage({super.key});

  @override
  State<SensoryEvaluationPage> createState() => _SensoryEvaluationPageState();
}

class _SensoryEvaluationPageState extends State<SensoryEvaluationPage> {
  // Sliders state
  Map<String, double> sliderValues = {
    'fragancia': 5.0,
    'aroma': 5.0,
    'sabor': 5.0,
    'sabor_residual': 5.0,
    'acidez': 5.0,
    'dulzor': 5.0,
    'sensacion_boca': 5.0,
  };

  // Selected tags for flavor characteristics
  Set<String> selectedAromaTags = {};
  Set<String> selectedFlavorTags = {};
  Set<String> selectedBasicTasteTags = {};
  Set<String> selectedAftertasteTags = {};
  Set<String> selectedMouthFeelTags = {};

  String notesFragancia = '';
  String notesAroma = '';
  String notesSabor = '';
  String notesSaborResidual = '';
  String notesAcidez = '';
  String notesDulzor = '';
  String notesSensacionBoca = '';

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
        title: Text(
          'SENSORY EVALUATION',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Fragancia Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'FRAGANCIA',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['fragancia']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['fragancia'] = value);
                },
                notes: notesFragancia,
                onNotesChanged: (value) {
                  setState(() => notesFragancia = value);
                },
                selectedTags: selectedAromaTags,
                onTagSelected: (tag) {
                  setState(() {
                    if (selectedAromaTags.contains(tag)) {
                      selectedAromaTags.remove(tag);
                    } else {
                      selectedAromaTags.add(tag);
                    }
                  });
                },
                availableTags: const ['FLORAL', 'AFRUTADO', 'BAYAS', 'TOSTADO', 'CEREAL', 'QUEMADO'],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Aroma Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'AROMA',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['aroma']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['aroma'] = value);
                },
                notes: notesAroma,
                onNotesChanged: (value) {
                  setState(() => notesAroma = value);
                },
                selectedTags: selectedFlavorTags,
                onTagSelected: (tag) {
                  setState(() {
                    if (selectedFlavorTags.contains(tag)) {
                      selectedFlavorTags.remove(tag);
                    } else {
                      selectedFlavorTags.add(tag);
                    }
                  });
                },
                availableTags: const ['FRUTAS DESHIDRATADAS', 'CÍTRICOS', 'TABACO', 'ESPECIAS', 'DULCE'],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Sabor Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'SABOR',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['sabor']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['sabor'] = value);
                },
                notes: notesSabor,
                onNotesChanged: (value) {
                  setState(() => notesSabor = value);
                },
                selectedTags: selectedBasicTasteTags,
                onTagSelected: (tag) {
                  setState(() {
                    if (selectedBasicTasteTags.contains(tag)) {
                      selectedBasicTasteTags.remove(tag);
                    } else {
                      selectedBasicTasteTags.add(tag);
                    }
                  });
                },
                availableTags: const ['SALADO', 'AMARGO', 'ÁCIDO', 'UMAMI', 'DULCE', 'NUECES/CACAO'],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Sabor Residual Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'SABOR RESIDUAL',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['sabor_residual']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['sabor_residual'] = value);
                },
                notes: notesSaborResidual,
                onNotesChanged: (value) {
                  setState(() => notesSaborResidual = value);
                },
                selectedTags: selectedAftertasteTags,
                onTagSelected: (tag) {
                  setState(() {
                    if (selectedAftertasteTags.contains(tag)) {
                      selectedAftertasteTags.remove(tag);
                    } else {
                      selectedAftertasteTags.add(tag);
                    }
                  });
                },
                availableTags: const ['SALADO', 'AMARGO', 'ÁCIDO'],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Acidez Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'ACIDEZ',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['acidez']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['acidez'] = value);
                },
                notes: notesAcidez,
                onNotesChanged: (value) {
                  setState(() => notesAcidez = value);
                },
                selectedTags: {},
                onTagSelected: (_) {},
                availableTags: const [],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Dulzor Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'DULZOR',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['dulzor']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['dulzor'] = value);
                },
                notes: notesDulzor,
                onNotesChanged: (value) {
                  setState(() => notesDulzor = value);
                },
                selectedTags: {},
                onTagSelected: (_) {},
                availableTags: const [],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 30)),

          // Sensación en Boca Section
          SliverToBoxAdapter(
            child: FadeInUp(
              child: _SensorySectionWidget(
                title: 'SENSACIÓN EN BOCA',
                intensity: 'INTENSIDAD',
                sliderValue: sliderValues['sensacion_boca']!,
                onSliderChanged: (value) {
                  setState(() => sliderValues['sensacion_boca'] = value);
                },
                notes: notesSensacionBoca,
                onNotesChanged: (value) {
                  setState(() => notesSensacionBoca = value);
                },
                selectedTags: selectedMouthFeelTags,
                onTagSelected: (tag) {
                  setState(() {
                    if (selectedMouthFeelTags.contains(tag)) {
                      selectedMouthFeelTags.remove(tag);
                    } else {
                      selectedMouthFeelTags.add(tag);
                    }
                  });
                },
                availableTags: const ['ÁSPERO', 'SUAVE', 'METÁLICO', 'ACEITOSO', 'OEJA SECA LA BOCA'],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),

          // Save Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _saveEvaluation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'GUARDAR EVALUACIÓN',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  void _saveEvaluation() {
    // TODO: Implement save evaluation logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evaluación guardada correctamente'),
        backgroundColor: AppColors.secondary,
      ),
    );
    Navigator.pop(context);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          // Intensity Label
          Text(
            intensity,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary.withOpacity(0.6),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          // Slider with value display
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      elevation: 4,
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                  ),
                  child: Slider(
                    value: sliderValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: onSliderChanged,
                    activeColor: AppColors.secondary,
                    inactiveColor: AppColors.secondary.withOpacity(0.2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sliderValue.toStringAsFixed(1),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Notes TextField
          TextField(
            onChanged: onNotesChanged,
            decoration: InputDecoration(
              hintText: 'Notas...',
              hintStyle: GoogleFonts.montserrat(
                color: AppColors.textPrimary.withOpacity(0.4),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.textPrimary.withOpacity(0.2),
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: 3,
            style: GoogleFonts.montserrat(
              color: AppColors.textPrimary,
            ),
          ),
          // Tags if available
          if (availableTags.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) => onTagSelected(tag),
                  backgroundColor: Colors.transparent,
                  selectedColor: AppColors.secondary.withOpacity(0.2),
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.secondary : AppColors.textPrimary.withOpacity(0.6),
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.secondary : AppColors.textPrimary.withOpacity(0.2),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
