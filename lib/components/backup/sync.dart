import 'package:flutter/material.dart';

import '../../helpers/constants.dart'
    show dbExportArchiveName, dbLastUpdatedName;
import '../../helpers/dbio.dart';
import '../../helpers/logger.dart';

enum SyncStatus {
  waiting("Waiting for init"),
  metadataLoading("Metadata Loading"),
  metadataSynced("Metadata Synced"),
  syncing("Syncing"),
  syncFailed("Sync failed"),
  syncDone("Sync done");

  const SyncStatus(this.title);
  final String title;
}

enum SyncReason {
  unknown(false, "Some error occurred"),
  unsupported(false, "Platform is not supported"),
  notFound(false, "File not found"),
  signedOut(false, "User is not signed in"),

  uploaded(true, "File uploaded successfully"),
  downloaded(true, "File downloaded successfully"),
  alreadySynced(true, "Latest already synced");

  const SyncReason(this.status, this.title);
  final bool status; // true means sync success, false means false
  final String title;
}

// U: User definition
abstract class SyncBase<U> with ChangeNotifier {
  SyncStatus _syncStatus = SyncStatus.waiting;
  DateTime? _lastUpdatedAt;

  U? get currentUser;
  bool get isSupported => throw UnimplementedError();
  SyncStatus get syncStatus => _syncStatus;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  Future<void> checkSignIn();
  Future<void> signOut();

  Future<List<int>?> getFile(String fileName);
  Future<void> uploadFile(String filename, List<int> localData);

  Future<void> syncLastUpdatedAt() async {
    _syncStatus = SyncStatus.metadataLoading;
    notifyListeners();
    final bytes = await getFile(dbLastUpdatedName);
    if (bytes != null) {
      _lastUpdatedAt = DateTime.parse(String.fromCharCodes(bytes));
    }
    _syncStatus = SyncStatus.metadataSynced;
    notifyListeners();
  }

  Future<void> _upload() async {
    await uploadFile(dbExportArchiveName, await extractDbArchive());
    final lastUpdatedTime = await getLastUpdatedTime();
    await uploadFile(
      dbLastUpdatedName,
      lastUpdatedTime.toIso8601String().codeUnits,
    );
    _lastUpdatedAt = lastUpdatedTime;
    notifyListeners();
  }

  Future<bool> _download() async {
    await syncLastUpdatedAt();
    if (_lastUpdatedAt == null) {
      return false;
    }
    final fileContent = await getFile(dbExportArchiveName);
    if (fileContent == null) {
      return false;
    }
    await archiveToDb(fileContent);
    return true;
  }

  Future<SyncReason> _sync() async {
    _syncStatus = SyncStatus.syncing;
    notifyListeners();
    if (!isSupported) {
      _syncStatus = SyncStatus.syncFailed;
      notifyListeners();
      return SyncReason.unsupported;
    }
    await checkSignIn();
    if (currentUser == null) {
      _syncStatus = SyncStatus.syncFailed;
      notifyListeners();
      return SyncReason.signedOut;
    }
    await syncLastUpdatedAt();
    if (lastUpdatedAt == null) {
      await _upload();
      _syncStatus = SyncStatus.syncDone;
      notifyListeners();
      return SyncReason.uploaded;
    } else {
      final lastUpdatedTimeLocal = await getLastUpdatedTime();
      SyncReason reason = SyncReason.unknown;
      if (lastUpdatedTimeLocal.compareTo(lastUpdatedAt!) == 0) {
        reason = SyncReason.alreadySynced;
      } else if (lastUpdatedTimeLocal.compareTo(lastUpdatedAt!) > 0) {
        _upload();
        reason = SyncReason.uploaded;
      } else {
        _download();
        reason = SyncReason.downloaded;
      }
      _syncStatus = SyncStatus.syncDone;
      notifyListeners();
      return reason;
    }
  }

  Future<void> upload(BuildContext context) async {
    try {
      await _upload();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.uploaded.title),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> download(BuildContext context) async {
    try {
      final status = await _download();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status ? SyncReason.downloaded.title : SyncReason.notFound.title,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }

  Future<bool> sync(BuildContext context, {bool suppressErrors = false}) async {
    try {
      final syncReason = await _sync();
      if (context.mounted) {
        AppLogger.instance.i(syncReason.title);
        if (syncReason.status == false && suppressErrors == true) {
          return false;
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(syncReason.title),
          ),
        );
      }
      return syncReason.status;
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }
}
