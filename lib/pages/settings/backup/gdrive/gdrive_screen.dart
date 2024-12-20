import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gdrive_sync.dart';

@RoutePage()
class GDriveBackupScreen extends StatelessWidget {
  const GDriveBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GdriveSync>(
      create: (context) => GdriveSync(),
      child: GDriveBackupScreenList(),
    );
  }
}

class GDriveBackupScreenList extends StatefulWidget {
  const GDriveBackupScreenList({super.key});

  @override
  State<GDriveBackupScreenList> createState() => _GDriveBackupScreenState();
}

class _GDriveBackupScreenState extends State<GDriveBackupScreenList> {
  @override
  void initState() {
    Provider.of<GdriveSync>(context, listen: false).checkGoogleSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gdriveSync = Provider.of<GdriveSync>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup -> Google Drive"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: gdriveSync.currentUser?.photoUrl != null
                ? Image.network(gdriveSync.currentUser!.photoUrl!)
                : null,
            title: Text(gdriveSync.currentUser?.displayName ??
                gdriveSync.currentUser?.email ??
                "Not signed in"),
            subtitle: Text(gdriveSync.currentUser?.email ?? "Not found"),
          ),
          ListTile(
            title: gdriveSync.loaded == false
                ? Text("Loading...")
                : gdriveSync.metadataFile == null
                    ? Text("Backup not done yet")
                    : Text("Backup last done on ${gdriveSync.metadataFile!}"),
          ),
          ListTile(
            title: Text("Upload"),
            onTap: () => gdriveSync.upload(context),
          ),
          ListTile(
            title: Text("Download"),
            onTap: () => gdriveSync.download(context),
          ),
          ListTile(
            title: Text("Sync"),
            onTap: () => gdriveSync.sync(context),
          ),
        ],
      ),
    );
  }
}
