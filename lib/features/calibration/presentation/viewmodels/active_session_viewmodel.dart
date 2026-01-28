import 'package:flutter/foundation.dart';
import '../../domain/entities/calibration_method.dart';

class ActiveSessionViewModel extends ChangeNotifier {
  final CalibrationMethod method;
  
  // Lista de recetas en esta sesión
  List<Map<String, dynamic>> recipes = [];
  
  // Estado actual del formulario
  final Map<String, dynamic> currentRecipe = {};
  
  // Session info from setup page
  Map<String, dynamic> sessionInfo = {};

  ActiveSessionViewModel({required this.method});

  void setSessionInfo(Map<String, dynamic> info) {
    sessionInfo = info;
    notifyListeners();
  }

  void updateField(String key, dynamic value) {
    currentRecipe[key] = value;
    notifyListeners();
  }

  void saveRecipe() {
    // Merge session info with current recipe
    final completeRecipe = {
      ...sessionInfo,
      ...currentRecipe,
      'timestamp': DateTime.now().toIso8601String(),
    };
    recipes.add(completeRecipe);
    
    // Limpiar campos para la siguiente
    currentRecipe.clear(); 
    notifyListeners();
  }

  // Helpers para calcular ratio
  double? calculateRatio(double? dose, double? yieldAmount) {
    if (dose == null || dose == 0 || yieldAmount == null) return null;
    return yieldAmount / dose;
  }

  // Get the last saved recipe for BrewGPT analysis
  Map<String, dynamic>? getLastRecipe() {
    if (recipes.isNotEmpty) {
      return recipes.last;
    }
    return null;
  }

  // Get all recipes for context
  List<Map<String, dynamic>> getAllRecipes() {
    return List.from(recipes);
  }
}