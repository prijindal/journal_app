import 'dart:io';

import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;

import 'package:journal_app/protobufs/journal.pbserver.dart';

import 'journal.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    File file;
    if (Platform.isAndroid || Platform.isIOS) {
      final dbFolder = await getApplicationDocumentsDirectory();
      file = File(p.join(dbFolder.path, 'db.sqlite'));
    } else if (Platform.isLinux) {
      final homeFolder = Platform.environment['HOME'];
      file = File('$homeFolder/.config/journal_app/db.sqlite');
    }
    return VmDatabase(file);
  });
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [JournalDatabase])
class MyDatabase extends _$MyDatabase {
  static MyDatabase _instance;
  static MyDatabase getInstance() {
    if (_instance == null) {
      _instance = MyDatabase();
    }
    return _instance;
  }

  MyDatabase() : super(_openConnection());
  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  Future<List<Journal>> get allJournalEntries =>
      select<JournalDatabase, Journal>(journalDatabase).get();
}
