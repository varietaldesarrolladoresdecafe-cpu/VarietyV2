import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile({required this.repository});

  Future<UserProfile?> call() async {
    return await repository.getUserProfile();
  }
}

class SaveUserProfile {
  final UserProfileRepository repository;

  SaveUserProfile({required this.repository});

  Future<void> call(UserProfile profile) async {
    return await repository.saveUserProfile(profile);
  }
}
