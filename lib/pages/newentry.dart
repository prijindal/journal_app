import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../models/core.dart';
import '../models/drift.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({
    super.key,
    this.creationTime,
    this.description,
  });
  final DateTime? creationTime;
  final String? description;

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();

  static Future<void> newEntry({
    required BuildContext context,
  }) async {
    final entry = await showDialog<JournalEntryCompanion?>(
      context: context,
      builder: (BuildContext context) {
        return const JournalEntryForm();
      },
    );
    if (entry != null) {
      await MyDatabase.instance
          .into(MyDatabase.instance.journalEntry)
          .insert(entry);
    }
  }

  static Future<void> editEntry({
    required BuildContext context,
    required JournalEntryData journalEntry,
  }) async {
    final editedData = await showDialog<JournalEntryCompanion?>(
      context: context,
      builder: (BuildContext context) {
        return JournalEntryForm(
          creationTime: journalEntry.creationTime,
          description: journalEntry.description,
        );
      },
    );
    if (editedData != null) {
      (MyDatabase.instance.update(MyDatabase.instance.journalEntry)
            ..where((tbl) => tbl.id.equals(journalEntry.id)))
          .write(editedData);
    }
  }
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late final _controller = FleatherController(
    document: widget.description == null
        ? null
        : ParchmentDocument.fromJson(
            jsonDecode(widget.description!) as List<dynamic>,
          ),
  );
  late final DateTime _selectedDate =
      widget.creationTime?.toLocal() ?? DateTime.now();

  void _saveEntry() {
    Navigator.of(context).pop<JournalEntryCompanion>(
      JournalEntryCompanion(
        creationTime: drift.Value(_selectedDate),
        description: drift.Value(jsonEncode(_controller.document.toJson())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Entry"),
        actions: [
          IconButton(
            onPressed: _saveEntry,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FleatherEditor(
              controller: _controller,
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              autofocus: true,
            ),
          ),
          FleatherToolbar.basic(
            controller: _controller,
          )
        ],
      ),
    );
  }
}
