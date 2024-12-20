import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../helpers/logger.dart';
import 'gdrive_sync.dart';

class GDriveBackupTile extends StatefulWidget {
  const GDriveBackupTile({super.key});

  @override
  State<GDriveBackupTile> createState() => _GDriveBackupTileState();
}

class _GDriveBackupTileState extends State<GDriveBackupTile> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _checkGoogleSignIn();
    super.initState();
  }

  void _checkGoogleSignIn() async {
    if (await googleSignIn.isSignedIn()) {
      final currentUser = googleSignIn.currentUser;
      if (currentUser != null) {
        setState(() {
          _currentUser = currentUser;
        });
      }
    }
  }

  void _login() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final signedIn = await googleSignIn.signIn();
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
    return _currentUser != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/icon/gdrive.png',
                  width: 48,
                ),
                title: Text(_currentUser!.displayName ?? _currentUser!.email),
                subtitle: Text(_currentUser!.email),
                onTap: () async {
                  await AutoRouter.of(context).pushNamed(
                    "/gdrive/backup",
                  );
                },
              ),
            ],
          )
        : ListTile(
            leading: Image.asset(
              'assets/icon/gdrive.png',
              width: 48,
            ),
            title: const Text(
              "Login with google drive",
            ),
            onTap: _login,
          );
  }
}
