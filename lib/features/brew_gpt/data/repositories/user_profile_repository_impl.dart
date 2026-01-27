import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_local_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileLocalDataSource localDataSource;

  UserProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfile?> getUserProfile() {
    return localDataSource.getUserProfile();
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) {
    return localDataSource.saveUserProfile(profile);
  }

  @override
  Future<void> deleteUserProfile() {
    return localDataSource.deleteUserProfile();
  }
}
