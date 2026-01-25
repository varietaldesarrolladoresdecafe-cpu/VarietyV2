import 'package:flutter/foundation.dart';
import '../../domain/entities/calibration_method.dart';

class ActiveSessionViewModel extends ChangeNotifier {
  final CalibrationMethod method;
  
  // Lista de recetas en esta sesión
  List<Map<String, dynamic>> recipes = [];
  
  // Estado actual del formulario
  final Map<String, dynamic> currentRecipe = {};

  ActiveSessionViewModel({required this.method});

  void updateField(String key, dynamic value) {
    currentRecipe[key] = value;
    notifyListeners();
  }

  void saveRecipe() {
    recipes.add(Map.from(currentRecipe));
    // Limpiar campos para la siguiente, manteniendo algunos valores base si es necesario
    currentRecipe.clear(); 
    notifyListeners();
  }

  // Helpers para calcular ratio
  double? calculateRatio(double? dose, double? yieldAmount) {
    if (dose == null || dose == 0 || yieldAmount == null) return null;
    return yieldAmount / dose;
  }
}