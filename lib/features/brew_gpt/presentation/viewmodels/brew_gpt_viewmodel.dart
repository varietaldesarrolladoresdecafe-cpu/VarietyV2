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
        notifyListeners();
      },
    );
  }
}