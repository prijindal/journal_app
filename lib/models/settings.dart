import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../helpers/constants.dart';
import '../helpers/logger.dart';

enum ColorSeed {
  baseColor('Default', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

// Determines the way that hidden entries are encrypted
enum HiddenLockedMode {
  // unknown is only meant to be selected before initializing
  unknown('Invalid value'),

  none('Not Locked'),
  biometrics('Locked with biometrics'),
  pin("Locked using a pin");

  // TODO: Implement password encryption
  // password,

  const HiddenLockedMode(this.label);
  final String label;
}

class SettingsStorageNotifier with ChangeNotifier {
  ColorSeed _baseColor;
  ThemeMode _themeMode;
  HiddenLockedMode _hiddenLockedMode;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  SettingsStorageNotifier(
      this._themeMode, this._baseColor, this._hiddenLockedMode) {
    init();
  }

  static Future<void> writePin(String pin) async {
    AppLogger.instance.d("Writting $pin as $pinKey to shared_preferences");
    await SharedPreferencesAsync().setString(pinKey, pin);
    // TODO: Use flutter secure storage
    // await storage.write(key: pinKey, value: pin);
    AppLogger.instance.d("Written $pin as $pinKey to shared_preferences");
  }

  static Future<String?> readPin() async {
    AppLogger.instance.d("Reading $pinKey from shared_preferences");
    final pin = await SharedPreferencesAsync().getString(pinKey);
    // final pin = await storage.read(key: pinKey);
    AppLogger.instance.d("Read $pin as $pinKey from shared_preferences");
    return pin;
  }

  Future<void> _readThemeFromStorage() async {
    AppLogger.instance.d("Reading $appThemeMode from shared_preferences");
    final preference = await asyncPrefs.getString(appThemeMode);
    _themeMode = preference == null
        ? ThemeMode.system
        : ThemeMode.values.asNameMap()[preference] ?? ThemeMode.system;
    AppLogger.instance
        .d("Read $appThemeMode as $preference from shared_preferences");
  }

  Future<void> _readColorFromStorage() async {
    AppLogger.instance.d("Reading $appColorSeed from shared_preferences");
    final preference = await asyncPrefs.getString(appColorSeed);
    _baseColor = preference == null
        ? ColorSeed.baseColor
        : ColorSeed.values.asNameMap()[preference] ?? ColorSeed.baseColor;
    AppLogger.instance
        .d("Read $appColorSeed as $preference from shared_preferences");
  }

  Future<void> _readHiddenLockedMode() async {
    AppLogger.instance.d("Reading $hiddenLockedMode from shared_preferences");
    final preference = await asyncPrefs.getString(hiddenLockedMode);
    _hiddenLockedMode = preference == null
        ? HiddenLockedMode.none
        : HiddenLockedMode.values.asNameMap()[preference] ??
            HiddenLockedMode.none;
    AppLogger.instance
        .d("Read $hiddenLockedMode as $preference from shared_preferences");
  }

  void init() async {
    await Future.wait(
      [
        _readThemeFromStorage(),
        _readColorFromStorage(),
        _readHiddenLockedMode(),
      ],
    );
    notifyListeners();
  }

  HiddenLockedMode getHiddenLockedMode() => _hiddenLockedMode;

  ThemeMode getTheme() => _themeMode;

  ColorSeed getBaseColor() => _baseColor;

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await asyncPrefs.setString(
      appThemeMode,
      themeMode.name,
    );
    AppLogger.instance
        .d("Written ${themeMode.name} as $appThemeMode to shared_preferences");
    notifyListeners();
  }

  Future<void> setColor(ColorSeed color) async {
    _baseColor = color;
    await asyncPrefs.setString(
      appColorSeed,
      color.name,
    );
    AppLogger.instance
        .d("Written ${color.name} as $appColorSeed to shared_preferences");
    notifyListeners();
  }

  Future<void> setHiddenLockedMode(HiddenLockedMode newHiddenLockedMode) async {
    _hiddenLockedMode = newHiddenLockedMode;
    await asyncPrefs.setString(
      hiddenLockedMode,
      newHiddenLockedMode.name,
    );
    AppLogger.instance.d(
        "Written ${newHiddenLockedMode.name} as $hiddenLockedMode to shared_preferences");
    notifyListeners();
  }
}
