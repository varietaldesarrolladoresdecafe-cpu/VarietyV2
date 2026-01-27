import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/calibration/presentation/viewmodels/calibration_viewmodel.dart';
import '../../features/calibration/presentation/viewmodels/new_session_viewmodel.dart';
import '../../features/calibration/domain/usecases/get_saved_sessions.dart';
import '../../features/calibration/domain/repositories/calibration_repository.dart';
import '../../features/brew_gpt/presentation/viewmodels/brew_gpt_viewmodel.dart';
import '../../features/brew_gpt/domain/usecases/get_brew_advice.dart';
import '../../features/brew_gpt/domain/usecases/user_profile_usecases.dart';
import '../../features/brew_gpt/domain/repositories/brew_gpt_repository.dart';
import '../../features/brew_gpt/domain/repositories/user_profile_repository.dart';
import '../../features/brew_gpt/data/repositories/brew_gpt_repository_impl.dart';
import '../../features/brew_gpt/data/repositories/user_profile_repository_impl.dart';
import '../../features/brew_gpt/data/datasources/brew_gpt_remote_data_source.dart';
import '../../features/brew_gpt/data/datasources/user_profile_local_data_source.dart';
import '../../features/calibration/data/repositories/calibration_repository_impl.dart';
import '../../features/calibration/data/datasources/calibration_local_data_source.dart';
import '../database/app_database.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Calibration
  // ViewModel
  sl.registerFactory(() => CalibrationViewModel(getSavedSessions: sl()));
  sl.registerFactory(() => NewSessionViewModel());
  sl.registerFactory(() => BrewGPTViewModel(
    getBrewAdvice: sl(),
    getUserProfile: sl(),
    saveUserProfile: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => GetSavedSessions(sl()));
  sl.registerLazySingleton(() => GetBrewAdvice(sl()));
  sl.registerLazySingleton(() => GetUserProfile(repository: sl()));
  sl.registerLazySingleton(() => SaveUserProfile(repository: sl()));

  // Repository
  sl.registerLazySingleton<CalibrationRepository>(
    () => CalibrationRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<BrewGPTRepository>(
    () => BrewGPTRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(localDataSource: sl()),
  );
  
  // Data Sources
  sl.registerLazySingleton<CalibrationLocalDataSource>(
    () => CalibrationLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BrewGPTRemoteDataSource>(
    () => BrewGPTRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<UserProfileLocalDataSource>(
    () => UserProfileLocalDataSourceImpl(preferences: sl()),
  );

  // ! Core
  // Database
  sl.registerLazySingleton(() => AppDatabase());
  // External
  sl.registerLazySingleton(() => Dio());
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}