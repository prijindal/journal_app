import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../components/confirmation_dialog.dart';
import '../components/journal_entry_form.dart';
import '../models/core.dart';
import '../models/drift.dart';

@RoutePage()
class EditEntryScreen extends StatefulWidget {
  const EditEntryScreen({
    super.key,
    @pathParam required this.entryId,
  });

  final String entryId;

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  JournalEntryData? _journalEntry;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    final entry =
        await (MyDatabase.instance.select(MyDatabase.instance.journalEntry)
              ..where((tbl) => tbl.id.equals(widget.entryId)))
            .getSingle();
    setState(() {
      _journalEntry = entry;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_journalEntry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text("Loading"),
        ),
      );
    }
    final journalEntry = _journalEntry!;
    return JournalEntryForm(
      creationTime: journalEntry.creationTime,
      document: journalEntry.document,
      tags: journalEntry.tags,
      hidden: journalEntry.hidden,
      onDelete: () async {
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmationDialog(),
        );
        if (shouldDelete != null && shouldDelete) {
          await MyDatabase.instance.journalEntry
              .deleteWhere((tbl) => tbl.id.equals(journalEntry.id));
          return true;
        }
        return false;
      },
      onSave: (editedData) async {
        await (MyDatabase.instance.update(MyDatabase.instance.journalEntry)
              ..where((tbl) => tbl.id.equals(journalEntry.id)))
            .write(editedData);
      },
    );
  }
}
