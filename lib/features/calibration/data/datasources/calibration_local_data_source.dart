import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/calibration_session.dart';

abstract class CalibrationLocalDataSource {
  Future<List<CalibrationSession>> getSavedSessions();
  Future<void> saveSession(CalibrationSession session);
}

class CalibrationLocalDataSourceImpl implements CalibrationLocalDataSource {
  final AppDatabase database;

  CalibrationLocalDataSourceImpl(this.database);

  @override
  Future<List<CalibrationSession>> getSavedSessions() async {
    try {
      final sessions = await database.select(database.calibrationSessionsTable).get();
      return sessions.map((row) => CalibrationSession(
        id: row.id,
        coffeeName: row.coffeeName,
        method: row.method,
        date: row.date,
      )).toList();
    } catch (e) {
      throw const DatabaseFailure('Error al leer base de datos');
    }
  }

  @override
  Future<void> saveSession(CalibrationSession session) async {
    try {
      await database.into(database.calibrationSessionsTable).insert(
        CalibrationSessionsTableCompanion.insert(
          id: session.id,
          coffeeName: session.coffeeName,
          method: session.method,
          date: session.date,
        ),
      );
    } catch (e) {
      throw const DatabaseFailure('Error al guardar en base de datos');
    }
  }
}