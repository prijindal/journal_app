import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';

import '../helpers/logger.dart';
import 'core.dart';
import 'drift.dart';

Future<void> importFromJourney() async {
  String path = "D:\\Downloads\\JourneyBackup\\JourneyBackup";
  final dir = Directory(path);
  final content = dir.listSync();
  for (var element in content) {
    if (element.path.contains("journey-single") ||
        element.path.contains("journey-1725900956772.zip")) {
      final bytes = File(element.path).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final entry in archive) {
        if (entry.isFile) {
          final fileBytes = entry.readBytes();
          final fileContent = jsonDecode(String.fromCharCodes(fileBytes!));
          String htmlContent = fileContent["text"] as String;
          htmlContent = htmlContent.replaceAll('</p><p dir="auto">', "\n");
          htmlContent = htmlContent.replaceAll('<p dir="auto">', "");
          htmlContent = htmlContent.replaceAll('</p>', "\n");
          if (!htmlContent.endsWith("\n")) {
            htmlContent = "$htmlContent\n";
          }
          final existingEntries = await MyDatabase.instance
              .select(MyDatabase.instance.journalEntry)
              .get();
          if (existingEntries
              .where((a) =>
                  a.document.toDelta().first.toJson()["insert"] == htmlContent)
              .isEmpty) {
            // print(htmlContent);
            final document = ParchmentDocument.fromJson([
              {"insert": htmlContent}
            ]);
            final journalEntry = JournalEntryCompanion(
              document: Value(document),
              tags: Value(["Imported"]),
              creationTime: Value(DateTime.fromMillisecondsSinceEpoch(
                  fileContent["date_journal"] as int)),
            );
            await MyDatabase.instance
                .into(MyDatabase.instance.journalEntry)
                .insert(journalEntry);
          } else {
            AppLogger.instance.d("Already exist");
          }
        }
      }
    }
  }
}
