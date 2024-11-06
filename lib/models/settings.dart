import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart';
import '../helpers/logger.dart';

// Determines the way that hidden entries are encrypted
enum HiddenEncryptionMode {
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
  HiddenEncryptionMode _hiddenEncryptionMode;

  SettingsStorageNotifier(this._themeMode, this._hiddenEncryptionMode) {
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

  Future<void> _readHiddenEncryptionMode(SharedPreferences instance) async {
    AppLogger.instance
        .d("Reading $hiddenEncryptionMode from shared_preferences");
    final preference = instance.getString(hiddenEncryptionMode);
    _hiddenEncryptionMode = preference == null
        ? HiddenEncryptionMode.none
        : HiddenEncryptionMode.values.asNameMap()[preference] ??
            HiddenEncryptionMode.none;
    AppLogger.instance
        .d("Read $hiddenEncryptionMode as $preference from shared_preferences");
  }

  void init() async {
    final instance = await SharedPreferences.getInstance();
    await Future.wait(
      [
        _readThemeFromStorage(instance),
        _readHiddenEncryptionMode(instance),
      ],
    );
    notifyListeners();
  }

  HiddenEncryptionMode getHiddenEncryptionMode() => _hiddenEncryptionMode;

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

  Future<void> setHiddenEncryptionMode(
      HiddenEncryptionMode newHiddenEncryptionMode) async {
    _hiddenEncryptionMode = newHiddenEncryptionMode;
    final instance = await SharedPreferences.getInstance();
    await instance.setString(
      hiddenEncryptionMode,
      newHiddenEncryptionMode.name,
    );
    AppLogger.instance.d(
        "Written ${newHiddenEncryptionMode.name} as $hiddenEncryptionMode to shared_preferences");
    notifyListeners();
  }
}
