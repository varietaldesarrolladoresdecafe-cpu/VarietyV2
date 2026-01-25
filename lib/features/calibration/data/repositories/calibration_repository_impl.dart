import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/calibration_session.dart';
import '../../domain/repositories/calibration_repository.dart';
import '../datasources/calibration_local_data_source.dart';

class CalibrationRepositoryImpl implements CalibrationRepository {
  final CalibrationLocalDataSource dataSource;

  CalibrationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<CalibrationSession>>> getSavedSessions() async {
    try {
      final result = await dataSource.getSavedSessions();
      return Right(result);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(DatabaseFailure('Error desconocido en base de datos'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSession(CalibrationSession session) async {
    try {
      await dataSource.saveSession(session);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(DatabaseFailure('Error desconocido al guardar'));
    }
  }
}