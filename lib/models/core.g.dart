// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// ignore_for_file: type=lint
class $JournalEntryTable extends JournalEntry
    with TableInfo<$JournalEntryTable, JournalEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
      'hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
      clientDefault: () => false);
  @override
  List<GeneratedColumn> get $columns => [id, description, creationTime, hidden];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta,
          hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  JournalEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
      hidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
    );
  }

  @override
  $JournalEntryTable createAlias(String alias) {
    return $JournalEntryTable(attachedDatabase, alias);
  }
}

class JournalEntryData extends DataClass
    implements Insertable<JournalEntryData> {
  final String id;
  final String description;
  final DateTime creationTime;
  final bool hidden;
  const JournalEntryData(
      {required this.id,
      required this.description,
      required this.creationTime,
      required this.hidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['description'] = Variable<String>(description);
    map['creation_time'] = Variable<DateTime>(creationTime);
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  JournalEntryCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryCompanion(
      id: Value(id),
      description: Value(description),
      creationTime: Value(creationTime),
      hidden: Value(hidden),
    );
  }

  factory JournalEntryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryData(
      id: serializer.fromJson<String>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'description': serializer.toJson<String>(description),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  JournalEntryData copyWith(
          {String? id,
          String? description,
          DateTime? creationTime,
          bool? hidden}) =>
      JournalEntryData(
        id: id ?? this.id,
        description: description ?? this.description,
        creationTime: creationTime ?? this.creationTime,
        hidden: hidden ?? this.hidden,
      );
  JournalEntryData copyWithCompanion(JournalEntryCompanion data) {
    return JournalEntryData(
      id: data.id.present ? data.id.value : this.id,
      description:
          data.description.present ? data.description.value : this.description,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryData(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('creationTime: $creationTime, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, creationTime, hidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryData &&
          other.id == this.id &&
          other.description == this.description &&
          other.creationTime == this.creationTime &&
          other.hidden == this.hidden);
}

class JournalEntryCompanion extends UpdateCompanion<JournalEntryData> {
  final Value<String> id;
  final Value<String> description;
  final Value<DateTime> creationTime;
  final Value<bool> hidden;
  final Value<int> rowid;
  const JournalEntryCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.hidden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntryCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.creationTime = const Value.absent(),
    this.hidden = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : description = Value(description);
  static Insertable<JournalEntryData> custom({
    Expression<String>? id,
    Expression<String>? description,
    Expression<DateTime>? creationTime,
    Expression<bool>? hidden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (creationTime != null) 'creation_time': creationTime,
      if (hidden != null) 'hidden': hidden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntryCompanion copyWith(
      {Value<String>? id,
      Value<String>? description,
      Value<DateTime>? creationTime,
      Value<bool>? hidden,
      Value<int>? rowid}) {
    return JournalEntryCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      creationTime: creationTime ?? this.creationTime,
      hidden: hidden ?? this.hidden,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('creationTime: $creationTime, ')
          ..write('hidden: $hidden, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SharedDatabase extends GeneratedDatabase {
  _$SharedDatabase(QueryExecutor e) : super(e);
  $SharedDatabaseManager get managers => $SharedDatabaseManager(this);
  late final $JournalEntryTable journalEntry = $JournalEntryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [journalEntry];
}

typedef $$JournalEntryTableCreateCompanionBuilder = JournalEntryCompanion
    Function({
  Value<String> id,
  required String description,
  Value<DateTime> creationTime,
  Value<bool> hidden,
  Value<int> rowid,
});
typedef $$JournalEntryTableUpdateCompanionBuilder = JournalEntryCompanion
    Function({
  Value<String> id,
  Value<String> description,
  Value<DateTime> creationTime,
  Value<bool> hidden,
  Value<int> rowid,
});

class $$JournalEntryTableFilterComposer
    extends Composer<_$SharedDatabase, $JournalEntryTable> {
  $$JournalEntryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnFilters(column));
}

class $$JournalEntryTableOrderingComposer
    extends Composer<_$SharedDatabase, $JournalEntryTable> {
  $$JournalEntryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntryTableAnnotationComposer
    extends Composer<_$SharedDatabase, $JournalEntryTable> {
  $$JournalEntryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => column);

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);
}

class $$JournalEntryTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $JournalEntryTable,
    JournalEntryData,
    $$JournalEntryTableFilterComposer,
    $$JournalEntryTableOrderingComposer,
    $$JournalEntryTableAnnotationComposer,
    $$JournalEntryTableCreateCompanionBuilder,
    $$JournalEntryTableUpdateCompanionBuilder,
    (
      JournalEntryData,
      BaseReferences<_$SharedDatabase, $JournalEntryTable, JournalEntryData>
    ),
    JournalEntryData,
    PrefetchHooks Function()> {
  $$JournalEntryTableTableManager(_$SharedDatabase db, $JournalEntryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntryCompanion(
            id: id,
            description: description,
            creationTime: creationTime,
            hidden: hidden,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String description,
            Value<DateTime> creationTime = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntryCompanion.insert(
            id: id,
            description: description,
            creationTime: creationTime,
            hidden: hidden,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalEntryTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $JournalEntryTable,
    JournalEntryData,
    $$JournalEntryTableFilterComposer,
    $$JournalEntryTableOrderingComposer,
    $$JournalEntryTableAnnotationComposer,
    $$JournalEntryTableCreateCompanionBuilder,
    $$JournalEntryTableUpdateCompanionBuilder,
    (
      JournalEntryData,
      BaseReferences<_$SharedDatabase, $JournalEntryTable, JournalEntryData>
    ),
    JournalEntryData,
    PrefetchHooks Function()>;

class $SharedDatabaseManager {
  final _$SharedDatabase _db;
  $SharedDatabaseManager(this._db);
  $$JournalEntryTableTableManager get journalEntry =>
      $$JournalEntryTableTableManager(_db, _db.journalEntry);
}
