import 'dart:convert';

import 'package:drift/drift.dart';

import '../models/core.dart';
import '../models/drift.dart';
import 'logger.dart';

Future<String> extractDbJson() async {
  final entries =
      await MyDatabase.instance.select(MyDatabase.instance.journalEntry).get();
  String encoded = jsonEncode(
    {
      "entries": entries,
      "created_at": DateTime.now().toIso8601String(),
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
        (a) => JournalEntryData.fromJson(a as Map<String, dynamic>),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  });
  AppLogger.instance.d("Loaded data into database");
}
