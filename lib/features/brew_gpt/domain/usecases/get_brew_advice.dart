import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/brew_advice.dart';
import '../repositories/brew_gpt_repository.dart';

class GetBrewAdvice implements UseCase<BrewAdvice, BrewAdviceParams> {
  final BrewGPTRepository repository;

  GetBrewAdvice(this.repository);

  @override
  Future<Either<Failure, BrewAdvice>> call(BrewAdviceParams params) async {
    return await repository.getAdvice(
      method: params.method,
      coffeeInfo: params.coffeeInfo,
      lastRecipe: params.lastRecipe,
      problem: params.problem,
      sensoryAnalysis: params.sensoryAnalysis,
    );
  }
}

class BrewAdviceParams extends Equatable {
  final String method;
  final String coffeeInfo;
  final Map<String, dynamic> lastRecipe;
  final String problem;
  final String sensoryAnalysis;

  const BrewAdviceParams({
    required this.method,
    required this.coffeeInfo,
    required this.lastRecipe,
    required this.problem,
    required this.sensoryAnalysis,
  });

  @override
  List<Object?> get props => [method, coffeeInfo, lastRecipe, problem, sensoryAnalysis];
}