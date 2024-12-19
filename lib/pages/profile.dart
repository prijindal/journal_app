import 'package:auto_route/auto_route.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

@RoutePage()
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ProfileScreen(
        providers: LoginScreen.authProviders,
        actions: [
          SignedOutAction((context) {
            AutoRouter.of(context).pushNamed("/settings");
          }),
        ],
      ),
    );
  }
}
