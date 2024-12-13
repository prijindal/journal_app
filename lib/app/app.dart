import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/settings.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../pages/search.dart';
import '../pages/settings/backup.dart';
import '../pages/settings/index.dart';
import '../pages/settings/security.dart';
import '../pages/settings/styling.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsStorageNotifier>(
      child: const MyMaterialApp(),
      create: (context) => SettingsStorageNotifier(
        ThemeMode.system,
        ColorSeed.baseColor,
        HiddenLockedMode.unknown,
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    AppLogger.instance.d("Building MyApp");
    return MaterialApp(
      routes: {
        "/": (context) => const HomeScreen(),
        "/search": (context) => const SearchScreen(),
        "/settings": (context) => const SettingsScreen(),
        "/settings/styling": (context) => const StylingSettingsScreen(),
        "/settings/backup": (context) => const BackupSettingsScreen(),
        "/settings/security": (context) => const SecuritySettingsScreen(),
        "/login": (context) => const LoginScreen(),
        '/profile': (context) {
          return ProfileScreen(
            providers: authProviders,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/settings');
              }),
            ],
          );
        },
      },
      initialRoute: "/",
      theme: lightTheme(settingsStorage.getBaseColor().color),
      darkTheme: darkTheme(settingsStorage.getBaseColor().color),
      themeMode: settingsStorage.getTheme(),
    );
  }
}
