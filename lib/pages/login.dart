import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
          );
        }

        return const _LoginChecker();
      },
    );
  }
}

class _LoginChecker extends StatefulWidget {
  const _LoginChecker();

  @override
  State<_LoginChecker> createState() => __LoginCheckerState();
}

class __LoginCheckerState extends State<_LoginChecker> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 100),
      _checkCurrentUser,
    );
  }

  void _checkCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
