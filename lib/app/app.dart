import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/settings.dart';
import '../router/app_router.dart';

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
    final appRouter = AppRouter();
    AppLogger.instance.d("Building MyApp");
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      theme: lightTheme(settingsStorage.getBaseColor().color),
      darkTheme: darkTheme(settingsStorage.getBaseColor().color),
      themeMode: settingsStorage.getTheme(),
    );
  }
}
