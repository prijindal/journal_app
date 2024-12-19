import 'package:flutter/material.dart';

class LocalStateNotifier with ChangeNotifier {
  bool _showHidden = false;
  List<String> _selectedEntries = [];
  String? _selectedEntryId;

  // Getters
  bool get showHidden => _showHidden;
  List<String> get selectedEntries => _selectedEntries;
  String? get selectedEntryId => _selectedEntryId;

  // Setters
  void setShowHidden(bool value) {
    _showHidden = value;
    notifyListeners();
  }

  void setSelectedEntries(List<String> value) {
    _selectedEntries = value;
    notifyListeners();
  }

  void setSelectedEntryId(String? value) {
    _selectedEntryId = value;
    notifyListeners();
  }
}
