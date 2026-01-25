import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/brew_advice.dart';

abstract class BrewGPTRepository {
  Future<Either<Failure, BrewAdvice>> getAdvice({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
  });
}