import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../models/core.dart';
import '../models/drift.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({
    super.key,
    required this.title,
    this.creationTime,
    this.description,
    this.hidden = false,
  });
  final DateTime? creationTime;
  final String? description;
  final bool hidden;
  final String title;

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();

  static Future<void> newEntry({
    required BuildContext context,
  }) async {
    final entry = await showDialog<JournalEntryCompanion?>(
      context: context,
      builder: (BuildContext context) {
        return const JournalEntryForm(title: "New Entry");
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
          title: journalEntry.creationTime.toString(),
          creationTime: journalEntry.creationTime,
          description: journalEntry.description,
          hidden: journalEntry.hidden,
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

  late var _hidden = widget.hidden;

  void _saveEntry() {
    Navigator.of(context).pop<JournalEntryCompanion>(
      JournalEntryCompanion(
        creationTime: drift.Value(_selectedDate),
        description: drift.Value(jsonEncode(_controller.document.toJson())),
        hidden: drift.Value(_hidden),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            leading: [
              defaultToggleStyleButtonBuilder(
                context,
                ParchmentAttribute.code,
                Icons.visibility,
                _hidden,
                () {
                  setState(() {
                    _hidden = !_hidden;
                  });
                },
              ),
              const SizedBox(width: 1),
              VerticalDivider(
                indent: 16,
                endIndent: 16,
                color: Colors.grey.shade400,
              )
            ],
          )
        ],
      ),
    );
  }
}
