import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../components/backup/sync.dart';

class FirebaseSync extends SyncBase<auth.User> {
  @override
  bool get isSupported => Firebase.apps.isNotEmpty;

  @override
  auth.User? get currentUser => auth.FirebaseAuth.instance.currentUser;

  @override
  Future<void> signOut() => auth.FirebaseAuth.instance.signOut();

  @override
  Future<void> checkSignIn() async {
    if (currentUser != null) {
      notifyListeners();
      syncLastUpdatedAt();
    }
  }

  @override
  Future<List<int>?> getFile(String fileName) async {
    if (currentUser == null) return null;
    final ref = FirebaseStorage.instance.ref("${currentUser!.uid}/$fileName");
    final dbBytes = await ref.getData();
    return dbBytes;
  }

  @override
  Future<void> uploadFile(String filename, List<int> localData) async {
    if (currentUser == null) return;
    final ref = FirebaseStorage.instance.ref("${currentUser!.uid}/$filename");
    await ref.putData(Uint8List.fromList(localData));
  }
}
