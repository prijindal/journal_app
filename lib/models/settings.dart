import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart';
import '../helpers/logger.dart';

// Determines the way that hidden entries are encrypted
enum HiddenLockedMode {
  // unknown is only meant to be selected before initializing
  unknown,

  none,
  biometrics,

  // TODO: Implement pin encryption
  // pin,
  // password,
}

class SettingsStorageNotifier with ChangeNotifier {
  ThemeMode _themeMode;
  HiddenLockedMode _hiddenLockedMode;

  SettingsStorageNotifier(this._themeMode, this._hiddenLockedMode) {
    init();
  }

  Future<void> _readThemeFromStorage(SharedPreferences instance) async {
    AppLogger.instance.d("Reading $appThemeMode from shared_preferences");
    final preference = instance.getString(appThemeMode);
    _themeMode = preference == null
        ? ThemeMode.system
        : ThemeMode.values.asNameMap()[preference] ?? ThemeMode.system;
    AppLogger.instance
        .d("Read $appThemeMode as $preference from shared_preferences");
  }

  Future<void> _readHiddenLockedMode(SharedPreferences instance) async {
    AppLogger.instance.d("Reading $hiddenLockedMode from shared_preferences");
    final preference = instance.getString(hiddenLockedMode);
    _hiddenLockedMode = preference == null
        ? HiddenLockedMode.none
        : HiddenLockedMode.values.asNameMap()[preference] ??
            HiddenLockedMode.none;
    AppLogger.instance
        .d("Read $hiddenLockedMode as $preference from shared_preferences");
  }

  void init() async {
    final instance = await SharedPreferences.getInstance();
    await Future.wait(
      [
        _readThemeFromStorage(instance),
        _readHiddenLockedMode(instance),
      ],
    );
    notifyListeners();
  }

  HiddenLockedMode getHiddenLockedMode() => _hiddenLockedMode;

  ThemeMode getTheme() => _themeMode;

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final instance = await SharedPreferences.getInstance();
    await instance.setString(
      appThemeMode,
      themeMode.name,
    );
    AppLogger.instance
        .d("Written ${themeMode.name} as $appThemeMode to shared_preferences");
    notifyListeners();
  }

  Future<void> setHiddenLockedMode(HiddenLockedMode newHiddenLockedMode) async {
    _hiddenLockedMode = newHiddenLockedMode;
    final instance = await SharedPreferences.getInstance();
    await instance.setString(
      hiddenLockedMode,
      newHiddenLockedMode.name,
    );
    AppLogger.instance.d(
        "Written ${newHiddenLockedMode.name} as $hiddenLockedMode to shared_preferences");
    notifyListeners();
  }
}
