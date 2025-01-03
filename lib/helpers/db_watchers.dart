import "dart:async";

import 'package:drift/drift.dart' as drift;

import "../models/core.dart";
import "../models/drift.dart";

Stream<List<JournalEntryData>> journalListSubscribe({
  bool showHidden = false,
  String? searchText,
}) {
  var query = MyDatabase.instance.journalEntry.select();
  if (!showHidden) {
    query.where((tbl) => tbl.hidden.equals(false));
  }
  if (searchText != null && searchText.isNotEmpty) {
    query = query
      ..where((tbl) =>
          tbl.tags.contains(searchText) | tbl.document.contains(searchText));
  }
  return (query
        ..orderBy(
          [
            (t) => drift.OrderingTerm(
                  expression: t.creationTime,
                  mode: drift.OrderingMode.desc,
                ),
          ],
        ))
      .watch();
}

Stream<JournalEntryData> journalEntrySubscribe({
  required String entryId,
}) {
  var query = MyDatabase.instance.select(MyDatabase.instance.journalEntry)
    ..where((tbl) => tbl.id.equals(entryId));
  return query.watchSingle();
}
