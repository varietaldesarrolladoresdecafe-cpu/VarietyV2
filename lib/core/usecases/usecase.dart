import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Parameters wrapper
class NoParams {}

// Base interface for all UseCases
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}