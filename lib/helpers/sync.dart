import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';

import '../models/core.dart';
import '../models/drift.dart';
import 'logger.dart';

Future<String> extractDbJson() async {
  final entries =
      await MyDatabase.instance.select(MyDatabase.instance.journalEntry).get();
  String encoded = jsonEncode(
    {
      "entries": entries,
    },
  );
  AppLogger.instance.i("Extracted data from database");
  return encoded;
}

Future<void> jsonToDb(String jsonEncoded) async {
  final decoded = jsonDecode(jsonEncoded);
  List<dynamic> entries = decoded["entries"] as List<dynamic>;
  await MyDatabase.instance.batch((batch) {
    batch.insertAll(
      MyDatabase.instance.journalEntry,
      entries.map(
        (a) {
          // Workaround to make it so that the document in json is properly inserted back to db
          a["document"] =
              ParchmentDocument.fromJson(a["document"] as List<dynamic>);
          a["tags"] = (a["tags"] as List<dynamic>)
              .map<String>((a) => a as String)
              .toList();
          a["updationTime"] = (a["updationTime"] ?? DateTime.now());
          a["creationTime"] = (a["creationTime"] ?? DateTime.now());
          a["hidden"] = (a["hidden"] ?? false);
          return JournalEntryData.fromJson(a as Map<String, dynamic>);
        },
      ),
      mode: InsertMode.insertOrIgnore,
    );
  });
  AppLogger.instance.d("Loaded data into database");
}
