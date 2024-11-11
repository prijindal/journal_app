import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './helpers/logger.dart';
import './pages/home.dart';
import 'helpers/constants.dart';
import 'models/settings.dart';
import 'pages/login.dart';
import 'pages/search.dart';
import 'pages/settings.dart';
// import 'pages/login.dart';

void main() async {
  runApp(
    const MyApp(),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // Firebase app check is only supported on these platforms
      await FirebaseAppCheck.instance.activate(
        webProvider: recaptchaSiteKey != null
            ? ReCaptchaV3Provider(recaptchaSiteKey!)
            : null,
        androidProvider: AndroidProvider.playIntegrity,
      );
    }
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase cannot be initialized",
      error: e,
      stackTrace: stack,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsStorageNotifier>(
      child: const MyMaterialApp(),
      create: (context) => SettingsStorageNotifier(
        ThemeMode.system,
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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: settingsStorage.getTheme(),
    );
  }
}
