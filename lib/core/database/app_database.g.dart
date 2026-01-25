// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CalibrationSessionsTableTable extends CalibrationSessionsTable
    with
        TableInfo<
          $CalibrationSessionsTableTable,
          CalibrationSessionsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coffeeNameMeta = const VerificationMeta(
    'coffeeName',
  );
  @override
  late final GeneratedColumn<String> coffeeName = GeneratedColumn<String>(
    'coffee_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, coffeeName, method, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibration_sessions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalibrationSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('coffee_name')) {
      context.handle(
        _coffeeNameMeta,
        coffeeName.isAcceptableOrUnknown(data['coffee_name']!, _coffeeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_coffeeNameMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalibrationSessionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      coffeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coffee_name'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $CalibrationSessionsTableTable createAlias(String alias) {
    return $CalibrationSessionsTableTable(attachedDatabase, alias);
  }
}

class CalibrationSessionsTableData extends DataClass
    implements Insertable<CalibrationSessionsTableData> {
  final String id;
  final String coffeeName;
  final String method;
  final DateTime date;
  const CalibrationSessionsTableData({
    required this.id,
    required this.coffeeName,
    required this.method,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['coffee_name'] = Variable<String>(coffeeName);
    map['method'] = Variable<String>(method);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  CalibrationSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return CalibrationSessionsTableCompanion(
      id: Value(id),
      coffeeName: Value(coffeeName),
      method: Value(method),
      date: Value(date),
    );
  }

  factory CalibrationSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      coffeeName: serializer.fromJson<String>(json['coffeeName']),
      method: serializer.fromJson<String>(json['method']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'coffeeName': serializer.toJson<String>(coffeeName),
      'method': serializer.toJson<String>(method),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  CalibrationSessionsTableData copyWith({
    String? id,
    String? coffeeName,
    String? method,
    DateTime? date,
  }) => CalibrationSessionsTableData(
    id: id ?? this.id,
    coffeeName: coffeeName ?? this.coffeeName,
    method: method ?? this.method,
    date: date ?? this.date,
  );
  CalibrationSessionsTableData copyWithCompanion(
    CalibrationSessionsTableCompanion data,
  ) {
    return CalibrationSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      coffeeName: data.coffeeName.present
          ? data.coffeeName.value
          : this.coffeeName,
      method: data.method.present ? data.method.value : this.method,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationSessionsTableData(')
          ..write('id: $id, ')
          ..write('coffeeName: $coffeeName, ')
          ..write('method: $method, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, coffeeName, method, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationSessionsTableData &&
          other.id == this.id &&
          other.coffeeName == this.coffeeName &&
          other.method == this.method &&
          other.date == this.date);
}

class CalibrationSessionsTableCompanion
    extends UpdateCompanion<CalibrationSessionsTableData> {
  final Value<String> id;
  final Value<String> coffeeName;
  final Value<String> method;
  final Value<DateTime> date;
  final Value<int> rowid;
  const CalibrationSessionsTableCompanion({
    this.id = const Value.absent(),
    this.coffeeName = const Value.absent(),
    this.method = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalibrationSessionsTableCompanion.insert({
    required String id,
    required String coffeeName,
    required String method,
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       coffeeName = Value(coffeeName),
       method = Value(method),
       date = Value(date);
  static Insertable<CalibrationSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? coffeeName,
    Expression<String>? method,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coffeeName != null) 'coffee_name': coffeeName,
      if (method != null) 'method': method,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalibrationSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? coffeeName,
    Value<String>? method,
    Value<DateTime>? date,
    Value<int>? rowid,
  }) {
    return CalibrationSessionsTableCompanion(
      id: id ?? this.id,
      coffeeName: coffeeName ?? this.coffeeName,
      method: method ?? this.method,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (coffeeName.present) {
      map['coffee_name'] = Variable<String>(coffeeName.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('coffeeName: $coffeeName, ')
          ..write('method: $method, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CalibrationSessionsTableTable calibrationSessionsTable =
      $CalibrationSessionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    calibrationSessionsTable,
  ];
}

typedef $$CalibrationSessionsTableTableCreateCompanionBuilder =
    CalibrationSessionsTableCompanion Function({
      required String id,
      required String coffeeName,
      required String method,
      required DateTime date,
      Value<int> rowid,
    });
typedef $$CalibrationSessionsTableTableUpdateCompanionBuilder =
    CalibrationSessionsTableCompanion Function({
      Value<String> id,
      Value<String> coffeeName,
      Value<String> method,
      Value<DateTime> date,
      Value<int> rowid,
    });

class $$CalibrationSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationSessionsTableTable> {
  $$CalibrationSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coffeeName => $composableBuilder(
    column: $table.coffeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalibrationSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationSessionsTableTable> {
  $$CalibrationSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coffeeName => $composableBuilder(
    column: $table.coffeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalibrationSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationSessionsTableTable> {
  $$CalibrationSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get coffeeName => $composableBuilder(
    column: $table.coffeeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$CalibrationSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalibrationSessionsTableTable,
          CalibrationSessionsTableData,
          $$CalibrationSessionsTableTableFilterComposer,
          $$CalibrationSessionsTableTableOrderingComposer,
          $$CalibrationSessionsTableTableAnnotationComposer,
          $$CalibrationSessionsTableTableCreateCompanionBuilder,
          $$CalibrationSessionsTableTableUpdateCompanionBuilder,
          (
            CalibrationSessionsTableData,
            BaseReferences<
              _$AppDatabase,
              $CalibrationSessionsTableTable,
              CalibrationSessionsTableData
            >,
          ),
          CalibrationSessionsTableData,
          PrefetchHooks Function()
        > {
  $$CalibrationSessionsTableTableTableManager(
    _$AppDatabase db,
    $CalibrationSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationSessionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CalibrationSessionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalibrationSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> coffeeName = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalibrationSessionsTableCompanion(
                id: id,
                coffeeName: coffeeName,
                method: method,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String coffeeName,
                required String method,
                required DateTime date,
                Value<int> rowid = const Value.absent(),
              }) => CalibrationSessionsTableCompanion.insert(
                id: id,
                coffeeName: coffeeName,
                method: method,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalibrationSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalibrationSessionsTableTable,
      CalibrationSessionsTableData,
      $$CalibrationSessionsTableTableFilterComposer,
      $$CalibrationSessionsTableTableOrderingComposer,
      $$CalibrationSessionsTableTableAnnotationComposer,
      $$CalibrationSessionsTableTableCreateCompanionBuilder,
      $$CalibrationSessionsTableTableUpdateCompanionBuilder,
      (
        CalibrationSessionsTableData,
        BaseReferences<
          _$AppDatabase,
          $CalibrationSessionsTableTable,
          CalibrationSessionsTableData
        >,
      ),
      CalibrationSessionsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CalibrationSessionsTableTableTableManager get calibrationSessionsTable =>
      $$CalibrationSessionsTableTableTableManager(
        _db,
        _db.calibrationSessionsTable,
      );
}
