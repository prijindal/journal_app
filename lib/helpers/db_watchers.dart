import "dart:async";

import 'package:drift/drift.dart' as drift;

import "../models/core.dart";
import "../models/drift.dart";

StreamSubscription<List<JournalEntryData>> journalListSubscribe({
  bool showHidden = false,
  String? searchText,
  required void Function(List<JournalEntryData>) listen,
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
  final subscription = (query
        ..orderBy(
          [
            (t) => drift.OrderingTerm(
                  expression: t.creationTime,
                  mode: drift.OrderingMode.desc,
                ),
          ],
        ))
      .watch()
      .listen(listen);
  return subscription;
}
