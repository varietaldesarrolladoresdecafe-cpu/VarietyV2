import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/brew_advice.dart';
import '../../domain/repositories/brew_gpt_repository.dart';
import '../datasources/brew_gpt_remote_data_source.dart';

class BrewGPTRepositoryImpl implements BrewGPTRepository {
  final BrewGPTRemoteDataSource remoteDataSource;

  BrewGPTRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BrewAdvice>> getAdvice({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
  }) async {
    try {
      final result = await remoteDataSource.getAdvice(
        method: method,
        coffeeInfo: coffeeInfo,
        lastRecipe: lastRecipe,
        problem: problem,
        sensoryAnalysis: sensoryAnalysis,
      );
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Error al conectar con BrewGPT'));
    }
  }
}