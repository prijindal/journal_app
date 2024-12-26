import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../../../components/backup/sync.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/google_http_client.dart';
import '../../../../helpers/logger.dart';

class GdriveSync extends SyncBase<GoogleSignInAccount> {
  DriveApi? _driveApi;

  static GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: googleSignInClientId,
    scopes: [
      DriveApi.driveAppdataScope,
    ],
    forceCodeForRefreshToken: false,
  );

  @override
  GoogleSignInAccount? get currentUser => googleSignIn.currentUser;

  @override
  bool get isSupported =>
      Firebase.apps.isNotEmpty && (Platform.isAndroid || Platform.isIOS);

  @override
  Future<void> signOut() => googleSignIn.signOut();

  Future<bool> signIn() async {
    final signedInUser = await googleSignIn.signIn();
    return signedInUser != null;
  }

  @override
  Future<void> checkSignIn() async {
    final alreadySignedIn = await googleSignIn.isSignedIn();
    GoogleSignInAccount? currentUser;
    if (alreadySignedIn) {
      AppLogger.instance.i("Google user already exist");
      currentUser = googleSignIn.currentUser;
    } else {
      AppLogger.instance
          .i("Google user doesn't exist, trying to sign in silently");
      currentUser = await googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      AppLogger.instance
          .i("Google user doesn't exist, trying to reauthenticate");
      currentUser = await googleSignIn.signInSilently(reAuthenticate: true);
    }
    if (currentUser != null) {
      final canAccess = await googleSignIn.canAccessScopes(googleSignIn.scopes);
      if (!canAccess) {
        await GdriveSync.googleSignIn.requestScopes(googleSignIn.scopes);
      }
      final headers = await currentUser.authHeaders;
      final client = GoogleHttpClient(headers);
      final driveApi = DriveApi(client);
      _driveApi = driveApi;
      notifyListeners();
      syncLastUpdatedAt();
    }
  }

  @override
  Future<List<int>?> getFile(String fileName) async {
    if (_driveApi == null) return null;
    final query = "name = '$fileName' and trashed = false";
    final driveFileList = await _driveApi!.files.list(
      q: query,
      spaces: 'appDataFolder',
    );
    if (driveFileList.files == null || driveFileList.files!.isEmpty) {
      return null;
    } else {
      final fileContent = await _driveApi!.files.get(
        driveFileList.files!.first.id!,
        downloadOptions: DownloadOptions.fullMedia,
      ) as Media;
      final byteContents = await fileContent.stream.toList();
      List<int> bytes = <int>[];
      for (var byteContent in byteContents) {
        bytes += byteContent;
      }
      return bytes;
    }
  }

  @override
  Future<void> uploadFile(String filename, List<int> localData) async {
    if (_driveApi == null) return;
    final stream = Stream.fromIterable([localData]);
    final media = Media(
      stream,
      localData.length,
      contentType: "application/json",
    );
    try {
      await _driveApi!.files.create(
        File(
          parents: ["appDataFolder"],
          name: filename,
        ),
        uploadMedia: media,
      );
    } catch (err) {
      debugPrint('G-Drive Error : $err');
    }
  }
}
