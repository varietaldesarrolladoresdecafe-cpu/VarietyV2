import 'package:equatable/equatable.dart';

class CoffeeSample extends Equatable {
  final String id;
  final int sampleNumber;
  final String sampleName;
  
  // Slider values for evaluation
  final Map<String, double> sliderValues;
  
  // Selected tags
  final Set<String> selectedAromaTags;
  final Set<String> selectedFlavorTags;
  final Set<String> selectedBasicTasteTags;
  final Set<String> selectedAftertasteTags;
  final Set<String> selectedMouthFeelTags;
  
  // Notes
  final String notesFragancia;
  final String notesAroma;
  final String notesSabor;
  final String notesSaborResidual;
  final String notesAcidez;
  final String notesDulzor;
  final String notesSensacionBoca;

  const CoffeeSample({
    required this.id,
    required this.sampleNumber,
    required this.sampleName,
    required this.sliderValues,
    required this.selectedAromaTags,
    required this.selectedFlavorTags,
    required this.selectedBasicTasteTags,
    required this.selectedAftertasteTags,
    required this.selectedMouthFeelTags,
    required this.notesFragancia,
    required this.notesAroma,
    required this.notesSabor,
    required this.notesSaborResidual,
    required this.notesAcidez,
    required this.notesDulzor,
    required this.notesSensacionBoca,
  });

  factory CoffeeSample.empty(int sampleNumber) {
    return CoffeeSample(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sampleNumber: sampleNumber,
      sampleName: 'Muestra $sampleNumber',
      sliderValues: {
        'fragancia': 5.0,
        'aroma': 5.0,
        'sabor': 5.0,
        'sabor_residual': 5.0,
        'acidez': 5.0,
        'dulzor': 5.0,
        'sensacion_boca': 5.0,
      },
      selectedAromaTags: {},
      selectedFlavorTags: {},
      selectedBasicTasteTags: {},
      selectedAftertasteTags: {},
      selectedMouthFeelTags: {},
      notesFragancia: '',
      notesAroma: '',
      notesSabor: '',
      notesSaborResidual: '',
      notesAcidez: '',
      notesDulzor: '',
      notesSensacionBoca: '',
    );
  }

  CoffeeSample copyWith({
    String? id,
    int? sampleNumber,
    String? sampleName,
    Map<String, double>? sliderValues,
    Set<String>? selectedAromaTags,
    Set<String>? selectedFlavorTags,
    Set<String>? selectedBasicTasteTags,
    Set<String>? selectedAftertasteTags,
    Set<String>? selectedMouthFeelTags,
    String? notesFragancia,
    String? notesAroma,
    String? notesSabor,
    String? notesSaborResidual,
    String? notesAcidez,
    String? notesDulzor,
    String? notesSensacionBoca,
  }) {
    return CoffeeSample(
      id: id ?? this.id,
      sampleNumber: sampleNumber ?? this.sampleNumber,
      sampleName: sampleName ?? this.sampleName,
      sliderValues: sliderValues ?? this.sliderValues,
      selectedAromaTags: selectedAromaTags ?? this.selectedAromaTags,
      selectedFlavorTags: selectedFlavorTags ?? this.selectedFlavorTags,
      selectedBasicTasteTags: selectedBasicTasteTags ?? this.selectedBasicTasteTags,
      selectedAftertasteTags: selectedAftertasteTags ?? this.selectedAftertasteTags,
      selectedMouthFeelTags: selectedMouthFeelTags ?? this.selectedMouthFeelTags,
      notesFragancia: notesFragancia ?? this.notesFragancia,
      notesAroma: notesAroma ?? this.notesAroma,
      notesSabor: notesSabor ?? this.notesSabor,
      notesSaborResidual: notesSaborResidual ?? this.notesSaborResidual,
      notesAcidez: notesAcidez ?? this.notesAcidez,
      notesDulzor: notesDulzor ?? this.notesDulzor,
      notesSensacionBoca: notesSensacionBoca ?? this.notesSensacionBoca,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sampleNumber,
    sampleName,
    sliderValues,
    selectedAromaTags,
    selectedFlavorTags,
    selectedBasicTasteTags,
    selectedAftertasteTags,
    selectedMouthFeelTags,
    notesFragancia,
    notesAroma,
    notesSabor,
    notesSaborResidual,
    notesAcidez,
    notesDulzor,
    notesSensacionBoca,
  ];
}
