import 'package:flutter/foundation.dart';
import '../../domain/entities/calibration_session.dart';
import '../../domain/entities/calibration_method.dart';

class NewSessionViewModel extends ChangeNotifier {
  CalibrationMethod? _selectedMethod;
  CalibrationMethod? get selectedMethod => _selectedMethod;

  // Campos comunes
  String? coffeeVariety;
  String? roastLevel; // Claro, Medio, Oscuro...
  int? restDays;
  String? beanDensity; // Fácil/Difícil de romper

  // Campos específicos
  String? espressoMachine;
  String? filterMethod; // V60, Chemex...

  void setMethod(CalibrationMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void updateCoffeeInfo({
    String? variety,
    String? roast,
    int? days,
    String? density,
  }) {
    if (variety != null) coffeeVariety = variety;
    if (roast != null) roastLevel = roast;
    if (days != null) restDays = days;
    if (density != null) beanDensity = density;
    notifyListeners();
  }

  // TODO: Implementar lógica de guardado
}