import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Parameters wrapper
class NoParams {}

// Base interface for all UseCases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}