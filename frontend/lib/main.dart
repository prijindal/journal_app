import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:journal_app/screens/editjournal.dart';
import 'package:journal_app/screens/journals.dart';
import 'package:journal_app/screens/loading.dart';
import 'package:journal_app/screens/login.dart';
import 'package:journal_app/screens/newjournal.dart';
import 'package:journal_app/screens/settings.dart';

/// If the current platform is a desktop platform that isn't yet supported by
/// TargetPlatform, override the default platform to one that is.
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => LoadingScreen(),
        "/login": (context) => LoginScreen(),
        "/journal": (context) => JournalsScreen(),
        "/new": (context) => NewJournalScreen(),
        "/edit": (context) => EditJournalScreen(),
        "/settings": (context) => SettingsScreen(),
      },
      // home: LoadingScreen(),
    );
  }
}
