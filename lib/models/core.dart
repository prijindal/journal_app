import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';
import 'package:uuid/uuid.dart';

import 'parchment_converted.dart';
import 'string_list.dart';

// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'core.g.dart';

const _uuid = Uuid();

class JournalEntry extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get document => text().map(const ParchmentDocumentConverter())();
  TextColumn get tags => text()
      .map(const StringListConverter())
      .withDefault(Constant(jsonEncode([])))();
  DateTimeColumn get creationTime => dateTime()();
  DateTimeColumn get updationTime => dateTime()();
  BoolColumn get hidden => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [JournalEntry])
class SharedDatabase extends _$SharedDatabase {
  SharedDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
