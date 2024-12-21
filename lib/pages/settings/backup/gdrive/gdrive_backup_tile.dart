import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/logger.dart';
import 'gdrive_sync.dart';

class GDriveBackupTile extends StatefulWidget {
  const GDriveBackupTile({super.key});

  @override
  State<GDriveBackupTile> createState() => _GDriveBackupTileState();
}

class _GDriveBackupTileState extends State<GDriveBackupTile> {
  @override
  void initState() {
    Provider.of<GdriveSync>(context, listen: false).checkSignIn();
    super.initState();
  }

  void _login() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final signedIn = await googleSignIn.signIn();
      if (signedIn != null) {
        await googleSignIn.signIn();
        // ignore: use_build_context_synchronously
        Provider.of<GdriveSync>(context, listen: false).checkSignIn();
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
    final gDriveSync = Provider.of<GdriveSync>(context);
    return gDriveSync.currentUser != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/icon/gdrive.png',
                  width: 48,
                ),
                title: Text(gDriveSync.currentUser!.displayName ??
                    gDriveSync.currentUser!.email),
                subtitle: Text(gDriveSync.currentUser!.email),
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
