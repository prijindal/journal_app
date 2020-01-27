import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class FlutterPersistor {
  SharedPreferences _sharedPreferences;
  static FlutterPersistor _instance;

  static FlutterPersistor getInstance() {
    if (_instance == null) {
      _instance = FlutterPersistor();
    }
    return _instance;
  }

  Future<void> initFlutterPersistor() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  String loadString(String key) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final string = _sharedPreferences.getString(key);
        return string;
      } else {
        final homeFolder = Platform.environment['HOME'];
        final file = File('$homeFolder/.config/journal_app/$key.txt');
        if (file.existsSync()) {
          return file.readAsStringSync();
        } else {
          return null;
        }
      }
    } on Exception {
      return null;
    }
  }

  Future<void> setString(String key, String value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences.setString(key, value);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/journal_app/$key.txt');
      file.createSync(recursive: true);
      await file.writeAsString(value);
    }
  }

  Uint8List loadBuffer(String key) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final string = _sharedPreferences.getString(key);
        return Uint8List.fromList(string.codeUnits);
      } else {
        final homeFolder = Platform.environment['HOME'];
        final file = File('$homeFolder/.config/journal_app/$key.txt');
        if (file.existsSync()) {
          return file.readAsBytesSync();
        } else {
          return null;
        }
      }
    } on Exception {
      return null;
    }
  }

  Future<void> setBuffer(String key, Uint8List value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences.setString(key, String.fromCharCodes(value));
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/journal_app/$key.txt');
      file.createSync(recursive: true);
      await file.writeAsBytes(value);
    }
  }

  Future<void> clearString(String key) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences.remove(key);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/journal_app/$key.txt');
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
    }
  }
}
