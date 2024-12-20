import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../../../helpers/constants.dart';
import '../../../../helpers/google_http_client.dart';
import '../../../../helpers/sync.dart';
import 'gdrive_sync.dart';

@RoutePage()
class GDriveBackupScreen extends StatefulWidget {
  const GDriveBackupScreen({super.key});

  @override
  State<GDriveBackupScreen> createState() => _GDriveBackupScreenState();
}

class _GDriveBackupScreenState extends State<GDriveBackupScreen> {
  GoogleSignInAccount? _currentUser;
  DriveApi? _driveApi;
  DateTime? _metadataFile;
  bool _loaded = false;

  @override
  void initState() {
    _checkGoogleSignIn();
    super.initState();
  }

  void _checkGoogleSignIn() async {
    final currentUser = googleSignIn.currentUser;
    if (currentUser != null) {
      final headers = await currentUser.authHeaders;
      final client = GoogleHttpClient(headers);
      final driveApi = DriveApi(client);
      setState(() {
        _currentUser = currentUser;
        _driveApi = driveApi;
      });
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
      final content = jsonDecode(String.fromCharCodes(byteContent[0]));
      setState(() {
        _metadataFile = DateTime.parse(content["created_at"] as String);
      });
    }
    setState(() {
      _loaded = true;
    });
  }

  void _upload() async {
    if (_driveApi == null) return;
    await _uploadFile(dbExportName, await extractDbJson());
    await _uploadFile(
      dbMetadataName,
      jsonEncode(
        {
          "created_at": DateTime.now().toIso8601String(),
        },
      ),
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
  }

  void _download() async {
    if (_driveApi == null) return;
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
        final byteContent = await fileContent.stream.toList();
        final content = String.fromCharCodes(byteContent[0]);
        await jsonToDb(content);
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File downloaded successfully"),
            ),
          );
        }
      }
    }
  }

  // void _sync() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup -> Google Drive"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: _currentUser?.photoUrl != null
                ? Image.network(_currentUser!.photoUrl!)
                : null,
            title: Text(_currentUser?.displayName ??
                _currentUser?.email ??
                "Not signed in"),
            subtitle: Text(_currentUser?.email ?? "Not found"),
          ),
          ListTile(
            title: _loaded == false
                ? Text("Loading...")
                : _metadataFile == null
                    ? Text("Backup not done yet")
                    : Text("Backup last done on ${_metadataFile!}"),
          ),
          ListTile(
            title: Text("Upload"),
            onTap: _upload,
          ),
          ListTile(
            title: Text("Download"),
            onTap: _download,
          ),
          // TODO
          // ListTile(
          //   title: Text("Sync"),
          //   onTap: _sync,
          // ),
        ],
      ),
    );
  }
}
