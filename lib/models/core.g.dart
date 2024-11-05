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
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _documentMeta =
      const VerificationMeta('document');
  @override
  late final GeneratedColumnWithTypeConverter<ParchmentDocument, String>
      document = GeneratedColumn<String>('document', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ParchmentDocument>(
              $JournalEntryTable.$converterdocument);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(jsonEncode([])))
          .withConverter<List<String>>($JournalEntryTable.$convertertags);
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
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, document, tags, creationTime, hidden];
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
    context.handle(_documentMeta, const VerificationResult.success());
    context.handle(_tagsMeta, const VerificationResult.success());
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      document: $JournalEntryTable.$converterdocument.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document'])!),
      tags: $JournalEntryTable.$convertertags.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
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

  static TypeConverter<ParchmentDocument, String> $converterdocument =
      const ParchmentDocumentConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class JournalEntryData extends DataClass
    implements Insertable<JournalEntryData> {
  final String id;
  final ParchmentDocument document;
  final List<String> tags;
  final DateTime creationTime;
  final bool hidden;
  const JournalEntryData(
      {required this.id,
      required this.document,
      required this.tags,
      required this.creationTime,
      required this.hidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['document'] = Variable<String>(
          $JournalEntryTable.$converterdocument.toSql(document));
    }
    {
      map['tags'] =
          Variable<String>($JournalEntryTable.$convertertags.toSql(tags));
    }
    map['creation_time'] = Variable<DateTime>(creationTime);
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  JournalEntryCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryCompanion(
      id: Value(id),
      document: Value(document),
      tags: Value(tags),
      creationTime: Value(creationTime),
      hidden: Value(hidden),
    );
  }

  factory JournalEntryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryData(
      id: serializer.fromJson<String>(json['id']),
      document: serializer.fromJson<ParchmentDocument>(json['document']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'document': serializer.toJson<ParchmentDocument>(document),
      'tags': serializer.toJson<List<String>>(tags),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  JournalEntryData copyWith(
          {String? id,
          ParchmentDocument? document,
          List<String>? tags,
          DateTime? creationTime,
          bool? hidden}) =>
      JournalEntryData(
        id: id ?? this.id,
        document: document ?? this.document,
        tags: tags ?? this.tags,
        creationTime: creationTime ?? this.creationTime,
        hidden: hidden ?? this.hidden,
      );
  JournalEntryData copyWithCompanion(JournalEntryCompanion data) {
    return JournalEntryData(
      id: data.id.present ? data.id.value : this.id,
      document: data.document.present ? data.document.value : this.document,
      tags: data.tags.present ? data.tags.value : this.tags,
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
          ..write('document: $document, ')
          ..write('tags: $tags, ')
          ..write('creationTime: $creationTime, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, document, tags, creationTime, hidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryData &&
          other.id == this.id &&
          other.document == this.document &&
          other.tags == this.tags &&
          other.creationTime == this.creationTime &&
          other.hidden == this.hidden);
}

class JournalEntryCompanion extends UpdateCompanion<JournalEntryData> {
  final Value<String> id;
  final Value<ParchmentDocument> document;
  final Value<List<String>> tags;
  final Value<DateTime> creationTime;
  final Value<bool> hidden;
  final Value<int> rowid;
  const JournalEntryCompanion({
    this.id = const Value.absent(),
    this.document = const Value.absent(),
    this.tags = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.hidden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntryCompanion.insert({
    this.id = const Value.absent(),
    required ParchmentDocument document,
    this.tags = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.hidden = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : document = Value(document);
  static Insertable<JournalEntryData> custom({
    Expression<String>? id,
    Expression<String>? document,
    Expression<String>? tags,
    Expression<DateTime>? creationTime,
    Expression<bool>? hidden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (document != null) 'document': document,
      if (tags != null) 'tags': tags,
      if (creationTime != null) 'creation_time': creationTime,
      if (hidden != null) 'hidden': hidden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntryCompanion copyWith(
      {Value<String>? id,
      Value<ParchmentDocument>? document,
      Value<List<String>>? tags,
      Value<DateTime>? creationTime,
      Value<bool>? hidden,
      Value<int>? rowid}) {
    return JournalEntryCompanion(
      id: id ?? this.id,
      document: document ?? this.document,
      tags: tags ?? this.tags,
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
    if (document.present) {
      map['document'] = Variable<String>(
          $JournalEntryTable.$converterdocument.toSql(document.value));
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($JournalEntryTable.$convertertags.toSql(tags.value));
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
          ..write('document: $document, ')
          ..write('tags: $tags, ')
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
  required ParchmentDocument document,
  Value<List<String>> tags,
  Value<DateTime> creationTime,
  Value<bool> hidden,
  Value<int> rowid,
});
typedef $$JournalEntryTableUpdateCompanionBuilder = JournalEntryCompanion
    Function({
  Value<String> id,
  Value<ParchmentDocument> document,
  Value<List<String>> tags,
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

  ColumnWithTypeConverterFilters<ParchmentDocument, ParchmentDocument, String>
      get document => $composableBuilder(
          column: $table.document,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

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

  ColumnOrderings<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumnWithTypeConverter<ParchmentDocument, String> get document =>
      $composableBuilder(column: $table.document, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

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
            Value<ParchmentDocument> document = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntryCompanion(
            id: id,
            document: document,
            tags: tags,
            creationTime: creationTime,
            hidden: hidden,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required ParchmentDocument document,
            Value<List<String>> tags = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JournalEntryCompanion.insert(
            id: id,
            document: document,
            tags: tags,
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
