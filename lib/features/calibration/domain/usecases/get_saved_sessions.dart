import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calibration_session.dart';
import '../repositories/calibration_repository.dart';

class GetSavedSessions implements UseCase<List<CalibrationSession>, NoParams> {
  final CalibrationRepository repository;

  GetSavedSessions(this.repository);

  @override
  Future<Either<Failure, List<CalibrationSession>>> call(NoParams params) async {
    return await repository.getSavedSessions();
  }
}