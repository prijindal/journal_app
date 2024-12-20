import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../helpers/constants.dart';
import '../../../../helpers/logger.dart';
import '../../../../helpers/sync.dart';

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

Future<auth.User?> getFirebaseUser() async {
  if (!isFirebaseInitialized()) {
    AppLogger.instance.i("Firebase App not initialized");
    return null;
  }
  return auth.FirebaseAuth.instance.currentUser;
}

Future<void> uploadFileToFirebase() async {
  final user = await getFirebaseUser();
  if (user != null) {
    final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
    final encoded = await extractDbJson();
    await ref.putString(encoded);
  }
}

Future<void> downloadFileFromFirebase() async {
  final user = await getFirebaseUser();
  if (user != null) {
    final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
    final dbBytes = await ref.getData();
    if (dbBytes != null) {
      final jsonEncoded = String.fromCharCodes(dbBytes);
      await jsonToDb(jsonEncoded);
    }
  }
}

Future<void> syncDbToFirebase() async {
  final user = await getFirebaseUser();
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
