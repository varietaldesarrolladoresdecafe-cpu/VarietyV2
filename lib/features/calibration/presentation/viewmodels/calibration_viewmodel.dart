import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/calibration_session.dart';
import '../../domain/usecases/get_saved_sessions.dart';

class CalibrationViewModel extends ChangeNotifier {
  final GetSavedSessions getSavedSessions;

  CalibrationViewModel({required this.getSavedSessions});

  List<CalibrationSession> _sessions = [];
  List<CalibrationSession> get sessions => _sessions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulación de delay
    await Future.delayed(const Duration(seconds: 1));

    final result = await getSavedSessions(NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (sessions) {
        _sessions = sessions;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Error de Servidor';
      case CacheFailure _:
        return 'Error de Caché';
      case DatabaseFailure _:
        return 'Error de Base de Datos';
      default:
        return 'Error Inesperado';
    }
  }
}