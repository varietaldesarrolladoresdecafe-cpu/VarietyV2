import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/calibration_session.dart';

abstract class CalibrationRepository {
  Future<Either<Failure, List<CalibrationSession>>> getSavedSessions();
  Future<Either<Failure, void>> saveSession(CalibrationSession session);
}