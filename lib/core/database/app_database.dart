import 'package:drift/drift.dart';
import 'connection/connection.dart';

// Parte generada automáticamente por drift
part 'app_database.g.dart';

// Tablas
class CalibrationSessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get coffeeName => text()();
  TextColumn get method => text()();
  DateTimeColumn get date => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CalibrationSessionsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
