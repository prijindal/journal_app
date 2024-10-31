import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

bool isFirebaseInitialized() {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase.apps error",
      error: e,
      stackTrace: stack,
    );
    return false;
  }
}

Future<auth.User?> getUser() async {
  if (!isFirebaseInitialized()) {
    AppLogger.instance.i("Firebase App not initialized");
    return null;
  }
  return auth.FirebaseAuth.instance.currentUser;
}

Future<void> uploadFile() async {
  final user = await getUser();
  if (user != null) {
    final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
    final encoded = await extractDbJson();
    await ref.putString(encoded);
  }
}

Future<void> downloadFile() async {
  final user = await getUser();
  if (user != null) {
    final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
    final dbBytes = await ref.getData();
    if (dbBytes != null) {
      final jsonEncoded = String.fromCharCodes(dbBytes);
      await jsonToDb(jsonEncoded);
    }
  }
}

Future<void> syncDb() async {
  final user = await getUser();
  if (user != null) {
    final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
    final dbBytes = await ref.getData();
    if (dbBytes != null) {
      final jsonEncoded = String.fromCharCodes(dbBytes);
      await jsonToDb(jsonEncoded);
    }
    final encoded = await extractDbJson();
    await ref.putString(encoded);
  }
}
