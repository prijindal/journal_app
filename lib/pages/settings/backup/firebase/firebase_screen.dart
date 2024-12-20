import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/constants.dart';
import '../../../../helpers/logger.dart';
import 'firebase_sync.dart';

@RoutePage()
class FirebaseBackupScreen extends StatefulWidget {
  const FirebaseBackupScreen({super.key});

  @override
  State<FirebaseBackupScreen> createState() => _FirebaseBackupScreenState();
}

class _FirebaseBackupScreenState extends State<FirebaseBackupScreen> {
  FullMetadata? metadata;

  @override
  void initState() {
    _syncMetadata();
    super.initState();
  }

  Future<void> _syncMetadata() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance.ref("${user!.uid}/$dbExportName");
      final metadata = await ref.getMetadata();
      setState(() {
        this.metadata = metadata;
      });
    } catch (e, stack) {
      parseErrorToString(e, stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
            onTap: () async {
              try {
                await syncDbToFirebase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sync successfully"),
                    ),
                  );
                }
                await _syncMetadata();
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
            },
          ),
          ListTile(
            title: const Text("Upload Database"),
            onTap: () async {
              try {
                await uploadFileToFirebase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("File uploaded successfully"),
                    ),
                  );
                }
                await _syncMetadata();
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
            },
          ),
          ListTile(
            title: const Text("Download database"),
            subtitle: metadata == null
                ? const Text("Database not synced yet")
                : Text("Last Synced at ${metadata!.updated}"),
            onTap: () async {
              try {
                await downloadFileFromFirebase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("File downloaded successfully"),
                    ),
                  );
                }
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
            },
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
