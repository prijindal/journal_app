import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../helpers/fileio.dart';
import 'firebase/firebase_backup_tile.dart';
import 'firebase/firebase_sync.dart';
import 'gdrive/gdrive_backup_tile.dart';

@RoutePage()
class BackupSettingsScreen extends StatelessWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Local Backup"),
          dense: true,
        ),
        ListTile(
          title: const Text("Download as JSON"),
          onTap: () => downloadContent(context),
        ),
        ListTile(
          title: const Text("Upload from file"),
          onTap: () => uploadContent(context),
        ),
        const CloudBackupTile(),
      ]),
    );
  }
}

class CloudBackupTile extends StatelessWidget {
  const CloudBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text("Cloud Backup"),
          dense: true,
        ),
        if (isFirebaseInitialized()) const FirebaseBackupTile(),
        if (isFirebaseInitialized() && (Platform.isAndroid || Platform.isIOS))
          const GDriveBackupTile(),
      ],
    );
  }
}
