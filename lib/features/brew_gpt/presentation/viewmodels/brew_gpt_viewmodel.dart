import 'package:flutter/foundation.dart';
import '../../domain/entities/brew_advice.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_brew_advice.dart';
import '../../domain/usecases/user_profile_usecases.dart';

class BrewGPTViewModel extends ChangeNotifier {
  final GetBrewAdvice getBrewAdvice;
  final GetUserProfile getUserProfile;
  final SaveUserProfile saveUserProfile;

  BrewGPTViewModel({
    required this.getBrewAdvice,
    required this.getUserProfile,
    required this.saveUserProfile,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BrewAdvice? _advice;
  BrewAdvice? get advice => _advice;

  String? _error;
  String? get error => _error;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  Map<String, dynamic>? _lastRecipe;
  Map<String, dynamic>? get lastRecipe => _lastRecipe;

  bool _shouldShowCalibrationOffer = false;
  bool get shouldShowCalibrationOffer => _shouldShowCalibrationOffer;

  Future<void> loadUserProfile() async {
    try {
      _userProfile = await getUserProfile() ?? UserProfile.empty();
      notifyListeners();
    } catch (e) {
      _userProfile = UserProfile.empty();
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await saveUserProfile(profile);
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      _error = 'Error al guardar perfil: $e';
      notifyListeners();
    }
  }

  // Set recipe for analysis
  void setRecipeForAnalysis(Map<String, dynamic> recipe) {
    _lastRecipe = recipe;
    _shouldShowCalibrationOffer = true;
    notifyListeners();
  }

  Future<void> askBrewGPT({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
  }) async {
    _isLoading = true;
    _error = null;
    _advice = null;
    notifyListeners();

    final result = await getBrewAdvice(BrewAdviceParams(
      method: method,
      coffeeInfo: coffeeInfo,
      lastRecipe: lastRecipe,
      problem: problem,
      sensoryAnalysis: sensoryAnalysis,
      userProfile: _userProfile,
    ));

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (advice) {
        _advice = advice;
        _isLoading = false;
        _shouldShowCalibrationOffer = false; // Hide offer after showing advice
        notifyListeners();
      },
    );
  }

  // Analyze recipe for calibration recommendation
  Future<void> analyzeRecipeForCalibration(Map<String, dynamic> recipe) async {
    _isLoading = true;
    _error = null;
    _advice = null;
    notifyListeners();

    // Extract information from recipe
    final dose = recipe['dose'] ?? 'No especificada';
    final yieldAmount = recipe['yield'] ?? 'No especificada';
    final grind = recipe['grind'] ?? 'No especificada';
    final time = recipe['time'] ?? 'No especificada';
    final sensory = recipe['sensory'] ?? 'Sin notas';
    final problem = recipe['problem'] ?? 'Sin problemas reportados';
    final variety = recipe['variety'] ?? 'No especificada';
    
    // Build comprehensive problem statement for BrewGPT
    String comprehensiveProblem = '''
Acabo de registrar una receta de espresso con los siguientes parámetros:
- Dosis: $dose g
- Rendimiento: $yieldAmount g
- Ajuste de molienda: $grind
- Tiempo total: $time segundos
- Notas sensoriales: $sensory
- Problema detectado: $problem
- Café: $variety
${recipe['days'] != null ? '- Días de reposo: ${recipe['days']} días' : ''}
${recipe['espresso_machine'] != null ? '- Máquina: ${recipe['espresso_machine']}' : ''}
${recipe['grinder'] != null ? '- Molino: ${recipe['grinder']}' : ''}
${recipe['preInfusionTime'] != null ? '- Tiempo pre-infusión: ${recipe['preInfusionTime']}s' : ''}
${recipe['temperature'] != null ? '- Temperatura: ${recipe['temperature']}°C' : ''}
${recipe['observations'] != null ? '- Observaciones: ${recipe['observations']}' : ''}

Por favor, analiza esta receta y dame recomendaciones específicas para calibrar y mejorar el espresso.
''';

    final result = await getBrewAdvice(BrewAdviceParams(
      method: 'Espresso',
      coffeeInfo: variety,
      lastRecipe: recipe,
      problem: comprehensiveProblem,
      sensoryAnalysis: sensory,
      userProfile: _userProfile,
    ));

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (advice) {
        _advice = advice;
        _isLoading = false;
        _shouldShowCalibrationOffer = false;
        notifyListeners();
      },
    );
  }
}