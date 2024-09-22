import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../helpers/constants.dart';
import '../helpers/google_http_client.dart';
import '../helpers/logger.dart';
import '../helpers/sync.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        if (isFirebaseInitialized()) const GoogleSignInSyncList(),
      ]),
    );
  }
}

class GoogleSignInSyncList extends StatefulWidget {
  const GoogleSignInSyncList({super.key});

  @override
  State<GoogleSignInSyncList> createState() => _GoogleSignInSyncListState();
}

class _GoogleSignInSyncListState extends State<GoogleSignInSyncList> {
  bool _isLoginLoading = true;
  final _googleSignIn = GoogleSignIn(
    clientId: googleSignInClientId,
    scopes: [
      DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  DriveApi? _driveApi;

  @override
  void initState() {
    _checkGoogleSignIn();
    super.initState();
  }

  void _checkGoogleSignIn() async {
    setState(() {
      _isLoginLoading = true;
    });
    final currentUser = await _googleSignIn.signInSilently();
    if (currentUser != null) {
      final headers = await currentUser.authHeaders;
      final client = GoogleHttpClient(headers);
      final driveApi = DriveApi(client);
      setState(() {
        _currentUser = currentUser;
        _isLoginLoading = false;
        _driveApi = driveApi;
      });
    } else {
      setState(() {
        _isLoginLoading = false;
      });
    }
  }

  void _login() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final signedIn = await _googleSignIn.signIn();
      if (signedIn != null) {
        _checkGoogleSignIn();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Google Login cancelled"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Error while login"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text("Sync"),
          dense: true,
        ),
        if (_isLoginLoading)
          const ListTile(
            title: Text("Checking google sign in ...."),
            enabled: false,
          ),
        if (!_isLoginLoading && _currentUser == null)
          ListTile(
            title: const Text("Login with Google"),
            onTap: _login,
          ),
        if (!_isLoginLoading && _currentUser != null)
          ListTile(
            title: Text(_currentUser!.email),
            enabled: false,
          ),
        if (!_isLoginLoading && _currentUser != null)
          DriveSyncList(driveApi: _driveApi!),
      ],
    );
  }
}

const folderName = "Journal_App";
const folderMime = "application/vnd.google-apps.folder";

class DriveSyncList extends StatefulWidget {
  const DriveSyncList({super.key, required this.driveApi});

  final DriveApi driveApi;

  @override
  State<DriveSyncList> createState() => _DriveSyncListState();
}

class _DriveSyncListState extends State<DriveSyncList> {
  bool _isLoading = true;
  File? _existingFile;

  @override
  initState() {
    _checkExistingFile();
    super.initState();
  }

  Future<File?> _isFileExist() async {
    const query = "name = '$dbExportName' and trashed = false";
    final driveFileList = await widget.driveApi.files.list(
      q: query,
      spaces: 'appDataFolder',
    );

    if (driveFileList.files == null || driveFileList.files!.isEmpty) {
      return null;
    }

    return driveFileList.files!.first;
  }

  void _checkExistingFile() async {
    setState(() {
      _isLoading = true;
    });
    final existingFile = await _isFileExist();
    if (existingFile != null) {
      debugPrint("File already exist");
      debugPrint(existingFile.toJson().toString());
      final fileContent = await widget.driveApi.files.get(
        existingFile.id!,
        downloadOptions: DownloadOptions.fullMedia,
      ) as Media;
      final content = await fileContent.stream.toList();
      final createdTime =
          jsonDecode(String.fromCharCodes(content[0]))["created_at"] as String;
      existingFile.createdTime = DateTime.parse(createdTime);
      setState(() {
        _existingFile = existingFile;
      });
    } else {
      setState(() {
        _existingFile = null;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _upload() async {
    setState(() {
      _isLoading = true;
    });
    final localData = await extractDbJson();
    final stream = Stream.fromIterable([localData.codeUnits]);
    final existingFile = await _isFileExist();
    final media = Media(
      stream,
      localData.codeUnits.length,
      contentType: "application/json",
    );
    if (existingFile != null) {
      debugPrint("File already exist, updating");
      try {
        // await widget.driveApi.files.delete(existingFile.id!);
        final updatedFile = await widget.driveApi.files.update(
          File(
            name: dbExportName,
            properties: {
              "created-at": DateTime.now().toString(),
            },
          ),
          existingFile.id!,
          uploadMedia: media,
        );
        debugPrint(updatedFile.toJson().toString());
      } catch (err) {
        debugPrint('G-Drive Error : $err');
      }
    } else {
      debugPrint("File doesn't exist, creating");
      try {
        final createdFile = await widget.driveApi.files.create(
          File(
            name: dbExportName,
            parents: ['appDataFolder'],
            properties: {
              "created-at": DateTime.now().toString(),
            },
          ),
          uploadMedia: media,
        );
        debugPrint(createdFile.toJson().toString());
      } catch (err) {
        debugPrint('G-Drive Error : $err');
      }
    }
    _checkExistingFile();
    setState(() {
      _isLoading = false;
    });
  }

  void _download() async {
    setState(() {
      _isLoading = true;
    });
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final existingFile = await _isFileExist();
    if (existingFile != null) {
      final downloadedFile = await widget.driveApi.files.get(
        existingFile.id!,
        downloadOptions: DownloadOptions.fullMedia,
      ) as Media;
      final content = await downloadedFile.stream.toList();
      await jsonToDb(String.fromCharCodes(content[0]));
    } else {
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text("File not found")));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ListTile(
        title: Text("Checking existing file..."),
        enabled: false,
      );
    }
    return Column(
      children: [
        ListTile(
          title: const Text("Upload"),
          onTap: _upload,
        ),
        ListTile(
          title: const Text("Download"),
          onTap: _download,
        ),
        ListTile(
          title: Text(_existingFile == null
              ? "Not available"
              : _existingFile!.createdTime.toString()),
          enabled: false,
        )
      ],
    );
  }
}
