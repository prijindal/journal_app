import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../../../helpers/constants.dart';
import '../../../../helpers/google_http_client.dart';
import '../../../../helpers/logger.dart';
import '../../../../helpers/sync.dart';
import '../../../../models/drift.dart';

final googleSignIn = GoogleSignIn(
  clientId: googleSignInClientId,
  scopes: [
    DriveApi.driveAppdataScope,
  ],
  forceCodeForRefreshToken: true,
);

class GdriveSync with ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  DateTime? _metadataFile;
  bool _loaded = false;

  DriveApi? _driveApi;

  GoogleSignInAccount? get currentUser => _currentUser;
  DateTime? get metadataFile => _metadataFile;
  bool get loaded => _loaded;

  Future<void> checkGoogleSignIn() async {
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
      final headers = await currentUser.authHeaders;
      final client = GoogleHttpClient(headers);
      final driveApi = DriveApi(client);
      _currentUser = currentUser;
      _driveApi = driveApi;
      notifyListeners();
      _checkExistingMetadataFile();
    }
  }

  Future<Media?> _getDriveFile(String filename) async {
    if (_driveApi == null) return null;
    final query = "name = '$filename' and trashed = false";
    final driveFileList = await _driveApi!.files.list(
      q: query,
      spaces: 'appDataFolder',
    );
    if (driveFileList.files == null || driveFileList.files!.isEmpty) {
      return null;
    } else {
      final content = await _driveApi!.files.get(
        driveFileList.files!.first.id!,
        downloadOptions: DownloadOptions.fullMedia,
      ) as Media;
      return content;
    }
  }

  Future<void> _uploadFile(String filename, String localData) async {
    if (_driveApi == null) return;
    final stream = Stream.fromIterable([localData.codeUnits]);
    final media = Media(
      stream,
      localData.codeUnits.length,
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

  Future<void> _checkExistingMetadataFile() async {
    if (_driveApi == null) return;
    final fileContent = await _getDriveFile(dbMetadataName);
    if (fileContent != null) {
      final byteContent = await fileContent.stream.toList();
      final content = String.fromCharCodes(byteContent[0]);
      _metadataFile = DateTime.parse(content);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<DateTime> _getLastUpdatedTime() async {
    final lastUpdatedRows = await (MyDatabase.instance.journalEntry.select()
          ..limit(1)
          ..orderBy([
            (t) => drift.OrderingTerm(
                  expression: t.updationTime,
                  mode: drift.OrderingMode.desc,
                ),
          ]))
        .get();
    if (lastUpdatedRows.isEmpty) {
      return DateTime.now();
    }
    final lastUpdatedTime = lastUpdatedRows.first.updationTime;
    return lastUpdatedTime;
  }

  Future<void> upload(BuildContext context) async {
    if (_driveApi == null) return;
    try {
      await _uploadFile(dbExportName, await extractDbJson());
      final lastUpdatedTime = await _getLastUpdatedTime();
      await _uploadFile(
        dbMetadataName,
        lastUpdatedTime.toIso8601String(),
      );
      await _checkExistingMetadataFile();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File uploaded successfully"),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error occurred while uploading"),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> download(BuildContext context) async {
    if (_driveApi == null) return;
    try {
      await _checkExistingMetadataFile();
      if (_metadataFile == null) {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File not found"),
            ),
          );
        }
      } else {
        final fileContent = await _getDriveFile(dbExportName);
        if (fileContent != null) {
          final byteContents = await fileContent.stream.toList();
          String content = "";
          for (var byteContent in byteContents) {
            content += String.fromCharCodes(byteContent);
          }
          await jsonToDb(content);
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File downloaded successfully"),
              ),
            );
          }
        } else {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File content empty on cloud"),
              ),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error occurred while downloading"),
          ),
        );
      }
      rethrow;
    }
  }

  Future<bool> syncDbToGdrive(BuildContext context) async {
    try {
      await checkGoogleSignIn();
      if (_currentUser == null) {
        return false;
      }
      if (_driveApi == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Can't sync"),
          ),
        );
        return false;
      }
      _checkExistingMetadataFile();
      if (_metadataFile == null) {
        // ignore: use_build_context_synchronously
        upload(context);
        return true;
      } else {
        final lastUpdatedTime = await _getLastUpdatedTime();
        if (lastUpdatedTime.compareTo(_metadataFile!) == 0) {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No need to sync"),
              ),
            );
          }
        } else if (lastUpdatedTime.compareTo(_metadataFile!) > 0) {
          // ignore: use_build_context_synchronously
          upload(context);
        } else {
          // ignore: use_build_context_synchronously
          download(context);
        }
        return true;
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some error occurred while syncing"),
          ),
        );
      }
      rethrow;
    }
  }
}
