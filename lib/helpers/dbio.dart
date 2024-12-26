import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';

import '../models/core.dart';
import '../models/drift.dart';
import 'constants.dart';
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

Future<List<int>> extractDbArchive({String? password}) async {
  final string = await extractDbJson();
  final encoder = ZipEncoder(password: password);
  final archive = Archive();
  archive.add(ArchiveFile.string(dbExportJsonName, string));
  final encoded = encoder.encode(
    archive,
    level: DeflateLevel.bestCompression,
  );
  return encoded;
}

Future<void> archiveToDb(List<int> archiveEncoded, {String? password}) async {
  final decoder = ZipDecoder();
  final archive = decoder.decodeBytes(archiveEncoded, password: password);
  final file = archive.findFile(dbExportJsonName);
  if (file == null) {
    throw ArchiveException("Invalid archive, no valid file found in the zip");
  }
  final byteContent = file.readBytes();
  if (byteContent == null) {
    throw ArchiveException(
        "Invalid archive, content of file in archive is empty");
  }
  final content = String.fromCharCodes(byteContent);
  await jsonToDb(content);
}

Future<DateTime> getLastUpdatedTime() async {
  final lastUpdatedRows = await (MyDatabase.instance.journalEntry.select()
        ..limit(1)
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.updationTime,
                mode: OrderingMode.desc,
              ),
        ]))
      .get();
  if (lastUpdatedRows.isEmpty) {
    return DateTime.now();
  }
  final lastUpdatedTime = lastUpdatedRows.first.updationTime;
  return lastUpdatedTime;
}
