import 'package:journal_app/protobufs/journal.pbserver.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class JournalSaveTypeConverter
    extends TypeConverter<Journal_JournalSaveType, int> {
  @override
  Journal_JournalSaveType mapToDart(int fromDb) {
    return Journal_JournalSaveType.valueOf(fromDb);
  }

  @override
  int mapToSql(Journal_JournalSaveType value) {
    return Journal_JournalSaveType.values.indexOf(value);
  }
}

var uuid = Uuid().v1();

@DataClassName("Journal")
class JournalDatabase extends Table {
  IntColumn get id => integer()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get content => text()();
  IntColumn get save_type =>
      integer().map<Journal_JournalSaveType>(JournalSaveTypeConverter())();
}
