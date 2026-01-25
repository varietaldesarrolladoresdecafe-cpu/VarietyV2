import 'package:flutter/foundation.dart';
import '../../domain/entities/brew_advice.dart';
import '../../domain/usecases/get_brew_advice.dart';

class BrewGPTViewModel extends ChangeNotifier {
  final GetBrewAdvice getBrewAdvice;

  BrewGPTViewModel({required this.getBrewAdvice});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BrewAdvice? _advice;
  BrewAdvice? get advice => _advice;

  String? _error;
  String? get error => _error;

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
        notifyListeners();
      },
    );
  }
}