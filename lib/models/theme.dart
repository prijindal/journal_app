import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart';
import '../helpers/logger.dart';

final deleteDismissible = Container(
  color: Colors.red,
  alignment: AlignmentDirectional.centerStart,
  child: const Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  ),
);

final editDismissible = Container(
  color: Colors.blue,
  alignment: AlignmentDirectional.centerEnd,
  child: const Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
    child: Icon(
      Icons.edit,
      color: Colors.white,
    ),
  ),
);

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeModeNotifier(this._themeMode) {
    init();
  }

  void init() {
    AppLogger.instance.d("Reading $appThemeMode from shared_preferences");
    SharedPreferences.getInstance().then((instance) {
      final preference = instance.getInt(appThemeMode);
      _themeMode = ThemeMode.values[preference ?? ThemeMode.system.index];
      AppLogger.instance
          .d("Read $appThemeMode as $preference from shared_preferences");
      notifyListeners();
    });
  }

  ThemeMode getTheme() => _themeMode;

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    (await SharedPreferences.getInstance()).setInt(
      appThemeMode,
      themeMode.index,
    );
    notifyListeners();
  }
}
