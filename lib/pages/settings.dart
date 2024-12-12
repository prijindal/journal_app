import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../helpers/fileio.dart';
import '../helpers/logger.dart';
import '../helpers/sync.dart';
import '../models/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
          title: const Text("Download as JSON"),
          onTap: () => downloadContent(context),
        ),
        ListTile(
          title: const Text("Upload from file"),
          onTap: () => uploadContent(context),
        ),
        // TODO: Add settings for group by
        // TODO: Add settings for date format
        // TODO: Add settings for sync on or off, add ability to sync every x days
        // TODO: Add settings for default view
        // TODO: Add settings for save on back button
        const ThemeSelectorTile(),
        const ColorSeedSelectorTile(),
        const LockHiddenSettingsTile(),
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

class ThemeSelectorTile extends StatelessWidget {
  const ThemeSelectorTile({super.key});

  String themeDataToText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return "System";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.light:
        return "Light";
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    return ListTile(
      subtitle: Text("Select a Theme Mode"),
      title: DropdownButton<ThemeMode>(
        value: settingsStorage.getTheme(),
        items: ThemeMode.values
            .map(
              (e) => DropdownMenuItem<ThemeMode>(
                value: e,
                child: Text(themeDataToText(e)),
              ),
            )
            .toList(),
        onChanged: (newValue) async {
          await settingsStorage.setTheme(newValue ?? ThemeMode.system);
        },
      ),
    );
  }
}

class ColorSeedSelectorTile extends StatelessWidget {
  const ColorSeedSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    return ListTile(
      subtitle: Text("Select a Color"),
      title: DropdownButton<ColorSeed>(
        value: settingsStorage.getBaseColor(),
        items: ColorSeed.values
            .map(
              (e) => DropdownMenuItem<ColorSeed>(
                value: e,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: 10,
                        top: 5.0,
                      ),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: e.color),
                    ),
                    Text(e.label),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (newValue) async {
          await settingsStorage.setColor(newValue ?? ColorSeed.baseColor);
        },
      ),
    );
  }
}

class LockHiddenSettingsTile extends StatefulWidget {
  const LockHiddenSettingsTile({super.key});

  @override
  State<LockHiddenSettingsTile> createState() => _LockHiddenSettingsTileState();
}

class _LockHiddenSettingsTileState extends State<LockHiddenSettingsTile> {
  List<HiddenLockedMode> _availableModes = [HiddenLockedMode.none];

  @override
  initState() {
    _checkLocalAuth();
    super.initState();
  }

  void _checkLocalAuth() async {
    if (!kIsWeb) {
      final LocalAuthentication auth = LocalAuthentication();
      final canCheckBiometrics = await auth.isDeviceSupported();
      if (canCheckBiometrics) {
        final availableBiometrics = await auth.getAvailableBiometrics();
        if (availableBiometrics.isEmpty) {
          AppLogger.instance.d("Biometrics not enabled on this device");
        } else {
          AppLogger.instance.d(availableBiometrics);
          setState(() {
            _availableModes = [
              HiddenLockedMode.none,
              HiddenLockedMode.biometrics
            ];
          });
        }
      } else {
        AppLogger.instance.d("Biometrics not supported on this device");
      }
    }
  }

  Widget _buildTitle() {
    if (_availableModes.length <= 1) {
      return Text("Locking not available");
    }
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    final currentLockedMode = settingsStorage.getHiddenLockedMode();
    return DropdownButton<HiddenLockedMode>(
      value: currentLockedMode,
      items: _availableModes
          .map(
            (e) => DropdownMenuItem<HiddenLockedMode>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
      onChanged: (newValue) async {
        if (newValue == HiddenLockedMode.biometrics ||
            currentLockedMode == HiddenLockedMode.biometrics) {
          final LocalAuthentication auth = LocalAuthentication();

          final authenticated = await auth.authenticate(
            localizedReason: "Biometrics scan for hiding entries",
          );
          if (!authenticated) {
            AppLogger.instance
                .i("Biometrics authenticated failed, not changing values");
            return;
          } else {
            AppLogger.instance.d(
                "Biometrics authenticated successful, enabling biometrics authentication");
          }
          // If new value or existing value is biometrics, authenticate using biometrics first
        }
        await settingsStorage
            .setHiddenLockedMode(newValue ?? HiddenLockedMode.none);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text("Select Locking method for hidden entries"),
      title: _buildTitle(),
    );
  }
}
