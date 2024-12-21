import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_sync.dart';

@RoutePage()
class FirebaseBackupScreen extends StatefulWidget {
  const FirebaseBackupScreen({super.key});

  @override
  State<FirebaseBackupScreen> createState() => _FirebaseBackupScreenState();
}

class _FirebaseBackupScreenState extends State<FirebaseBackupScreen> {
  @override
  void initState() {
    Provider.of<FirebaseSync>(context, listen: false).syncMetadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseSync = Provider.of<FirebaseSync>(context);
    final user = firebaseSync.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup -> Firebase"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading:
                user?.photoURL != null ? Image.network(user!.photoURL!) : null,
            title: Text(user?.displayName ??
                user?.email ??
                user?.uid ??
                "Not signed in"),
            subtitle: Text(user?.email ?? user?.uid ?? "Not found"),
            onTap: () async {
              await AutoRouter.of(context).pushNamed(
                "/firebase/profile",
              );
            },
          ),
          ListTile(
            title: const Text("Sync database"),
            onTap: () => firebaseSync.syncDbToFirebase(context),
          ),
          ListTile(
            title: const Text("Upload Database"),
            onTap: () => firebaseSync.uploadFileToFirebase(context),
          ),
          ListTile(
            title: const Text("Download database"),
            subtitle: firebaseSync.metadata == null
                ? const Text("Database not synced yet")
                : Text("Last Synced at ${firebaseSync.metadata!.updated}"),
            onTap: () => firebaseSync.downloadFileFromFirebase(context),
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
