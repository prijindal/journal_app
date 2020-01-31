// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Journal extends DataClass implements Insertable<Journal> {
  final int id;
  final String uuid;
  final String content;
  final Journal_JournalSaveType save_type;
  Journal(
      {@required this.id,
      @required this.uuid,
      @required this.content,
      @required this.save_type});
  factory Journal.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Journal(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      uuid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}uuid']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      save_type: $JournalDatabaseTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}save_type'])),
    );
  }
  factory Journal.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Journal(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      content: serializer.fromJson<String>(json['content']),
      save_type:
          serializer.fromJson<Journal_JournalSaveType>(json['save_type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'content': serializer.toJson<String>(content),
      'save_type': serializer.toJson<Journal_JournalSaveType>(save_type),
    };
  }

  @override
  JournalDatabaseCompanion createCompanion(bool nullToAbsent) {
    return JournalDatabaseCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      save_type: save_type == null && nullToAbsent
          ? const Value.absent()
          : Value(save_type),
    );
  }

  Journal copyWith(
          {int id,
          String uuid,
          String content,
          Journal_JournalSaveType save_type}) =>
      Journal(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        content: content ?? this.content,
        save_type: save_type ?? this.save_type,
      );
  @override
  String toString() {
    return (StringBuffer('Journal(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('content: $content, ')
          ..write('save_type: $save_type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(uuid.hashCode, $mrjc(content.hashCode, save_type.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Journal &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.content == this.content &&
          other.save_type == this.save_type);
}

class JournalDatabaseCompanion extends UpdateCompanion<Journal> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> content;
  final Value<Journal_JournalSaveType> save_type;
  const JournalDatabaseCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.content = const Value.absent(),
    this.save_type = const Value.absent(),
  });
  JournalDatabaseCompanion.insert({
    @required int id,
    @required String uuid,
    @required String content,
    @required Journal_JournalSaveType save_type,
  })  : id = Value(id),
        uuid = Value(uuid),
        content = Value(content),
        save_type = Value(save_type);
  JournalDatabaseCompanion copyWith(
      {Value<int> id,
      Value<String> uuid,
      Value<String> content,
      Value<Journal_JournalSaveType> save_type}) {
    return JournalDatabaseCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      content: content ?? this.content,
      save_type: save_type ?? this.save_type,
    );
  }
}

class $JournalDatabaseTable extends JournalDatabase
    with TableInfo<$JournalDatabaseTable, Journal> {
  final GeneratedDatabase _db;
  final String _alias;
  $JournalDatabaseTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  GeneratedTextColumn _uuid;
  @override
  GeneratedTextColumn get uuid => _uuid ??= _constructUuid();
  GeneratedTextColumn _constructUuid() {
    return GeneratedTextColumn('uuid', $tableName, false,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _save_typeMeta = const VerificationMeta('save_type');
  GeneratedIntColumn _save_type;
  @override
  GeneratedIntColumn get save_type => _save_type ??= _constructSaveType();
  GeneratedIntColumn _constructSaveType() {
    return GeneratedIntColumn(
      'save_type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, uuid, content, save_type];
  @override
  $JournalDatabaseTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'journal_database';
  @override
  final String actualTableName = 'journal_database';
  @override
  VerificationContext validateIntegrity(JournalDatabaseCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.uuid.present) {
      context.handle(
          _uuidMeta, uuid.isAcceptableValue(d.uuid.value, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (d.content.present) {
      context.handle(_contentMeta,
          content.isAcceptableValue(d.content.value, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    context.handle(_save_typeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Journal map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Journal.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(JournalDatabaseCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.uuid.present) {
      map['uuid'] = Variable<String, StringType>(d.uuid.value);
    }
    if (d.content.present) {
      map['content'] = Variable<String, StringType>(d.content.value);
    }
    if (d.save_type.present) {
      final converter = $JournalDatabaseTable.$converter0;
      map['save_type'] =
          Variable<int, IntType>(converter.mapToSql(d.save_type.value));
    }
    return map;
  }

  @override
  $JournalDatabaseTable createAlias(String alias) {
    return $JournalDatabaseTable(_db, alias);
  }

  static JournalSaveTypeConverter $converter0 = JournalSaveTypeConverter();
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $JournalDatabaseTable _journalDatabase;
  $JournalDatabaseTable get journalDatabase =>
      _journalDatabase ??= $JournalDatabaseTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [journalDatabase];
}
