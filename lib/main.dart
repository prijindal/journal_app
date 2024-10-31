import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './helpers/logger.dart';
import './models/theme.dart';
import './pages/home.dart';
import 'pages/login.dart';
import 'pages/settings.dart';
// import 'pages/login.dart';

void main() async {
  runApp(
    const MyApp(),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    return ChangeNotifierProvider<ThemeModeNotifier>(
      child: const MyMaterialApp(),
      create: (context) => ThemeModeNotifier(ThemeMode.system),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    AppLogger.instance.d("Building MyApp");
    return MaterialApp(
      routes: {
        "/": (context) => const MyHomePage(),
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
      themeMode: themeNotifier.getTheme(),
    );
  }
}
