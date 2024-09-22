import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../helpers/logger.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  final _googleSignIn = GoogleSignIn(
    scopes: [
      DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _checkGoogleSignIn();
    super.initState();
  }

  void _checkGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    final currentUser = await _googleSignIn.signInSilently();
    if (currentUser != null) {
      setState(() {
        _currentUser = currentUser;
        _isLoading = false;
      });
    } else {
      _isLoading = false;
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

  void _upload() {}

  void _download() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("Sync"),
            dense: true,
          ),
          if (_isLoading)
            const ListTile(
              title: Text("Checking google sign in ...."),
              enabled: false,
            ),
          if (!_isLoading && _currentUser == null)
            ListTile(
              title: const Text("Login with Google"),
              onTap: _login,
            ),
          if (!_isLoading && _currentUser != null)
            ListTile(
              title: Text(_currentUser!.email),
              enabled: false,
            ),
          if (!_isLoading && _currentUser != null)
            ListTile(
              title: const Text("Upload"),
              onTap: _upload,
            ),
          if (!_isLoading && _currentUser != null)
            ListTile(
              title: const Text("Download"),
              onTap: _download,
            ),
        ],
      ),
    );
  }
}
