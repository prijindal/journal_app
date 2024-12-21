import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

class FirebaseSync with ChangeNotifier {
  FullMetadata? _metadata;

  FullMetadata? get metadata => _metadata;
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;

  Future<auth.User?> _getFirebaseUser() async {
    if (!isFirebaseInitialized()) {
      AppLogger.instance.i("Firebase App not initialized");
      return null;
    }
    return auth.FirebaseAuth.instance.currentUser;
  }

  Future<void> syncMetadata() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance.ref("${user!.uid}/$dbExportName");
      final metadata = await ref.getMetadata();
      _metadata = metadata;
      notifyListeners();
    } catch (e, stack) {
      parseErrorToString(e, stack);
    }
  }

  Future<void> uploadFileToFirebase(BuildContext context) async {
    try {
      final user = await _getFirebaseUser();
      if (user != null) {
        final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
        final encoded = await extractDbJson();
        await ref.putString(encoded);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File uploaded successfully"),
          ),
        );
      }
      await syncMetadata();
    } catch (e, stack) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              parseErrorToString(e, stack, "Error while syncing"),
            ),
          ),
        );
      }
    }
  }

  Future<void> downloadFileFromFirebase(BuildContext context) async {
    try {
      final user = await _getFirebaseUser();
      if (user != null) {
        final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
        final dbBytes = await ref.getData();
        if (dbBytes != null) {
          final jsonEncoded = String.fromCharCodes(dbBytes);
          await jsonToDb(jsonEncoded);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File downloaded successfully"),
            ),
          );
        }
      }
    } catch (e, stack) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              parseErrorToString(e, stack, "Error while downloading"),
            ),
          ),
        );
      }
    }
  }

  Future<bool> syncDbToFirebase(BuildContext context) async {
    try {
      if (!isFirebaseInitialized()) {
        return false;
      }
      final user = await _getFirebaseUser();
      if (user == null) {
        return false;
      }
      final ref = FirebaseStorage.instance.ref("${user.uid}/$dbExportName");
      final dbBytes = await ref.getData();
      if (dbBytes != null) {
        final jsonEncoded = String.fromCharCodes(dbBytes);
        await jsonToDb(jsonEncoded);
      }
      final encoded = await extractDbJson();
      await ref.putString(encoded);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sync successfully"),
          ),
        );
      }
      await syncMetadata();
      return true;
    } catch (e, stack) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              parseErrorToString(e, stack, "Error while syncing"),
            ),
          ),
        );
      }
      rethrow;
    }
  }
}
