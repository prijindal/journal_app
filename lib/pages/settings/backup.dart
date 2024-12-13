import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../helpers/fileio.dart';
import '../../helpers/logger.dart';
import '../../helpers/sync.dart';

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
        if (isFirebaseInitialized()) const ProfileAuthTile(),
      ]),
    );
  }
}

class ProfileAuthTile extends StatefulWidget {
  const ProfileAuthTile({super.key});

  @override
  State<ProfileAuthTile> createState() => _ProfileAuthTileState();
}

class _ProfileAuthTileState extends State<ProfileAuthTile> {
  StreamSubscription<User?>? _subscription;
  User? user;
  FullMetadata? metadata;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        this.user = user;
      });
      _syncMetadata();
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _syncMetadata() async {
    if (user != null) {
      try {
        final ref = FirebaseStorage.instance.ref("${user!.uid}/$dbExportName");
        final metadata = await ref.getMetadata();
        setState(() {
          this.metadata = metadata;
        });
      } catch (e, stack) {
        parseErrorToString(e, stack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text("Cloud Backup"),
                dense: true,
              ),
              ListTile(
                leading: user!.photoURL != null
                    ? Image.network(user!.photoURL!)
                    : null,
                title: Text(user!.email ?? user!.uid),
                onTap: () async {
                  await Navigator.pushNamed(context, "/profile");
                },
              ),
              ListTile(
                title: const Text("Sync database"),
                onTap: () async {
                  try {
                    await syncDb();
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
                    await uploadFile();
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
                    await downloadFile();
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
          )
        : ListTile(
            title: const Text(
              "Login",
            ),
            onTap: () async {
              await Navigator.pushNamed(context, "/login");
            },
          );
  }
}
