import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import '../helpers/constants.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static List<AuthProvider<AuthListener, AuthCredential>>? authProviders = [
    EmailAuthProvider(),
    if (googleSignInClientId != null)
      GoogleProvider(clientId: googleSignInClientId!),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: authProviders,
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
      AutoRouter.of(context).maybePop();
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
