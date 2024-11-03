import 'package:drift/drift.dart' as drift;
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../components/journal_date.dart';
import '../helpers/logger.dart';
import '../models/core.dart';
import '../models/drift.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({
    super.key,
    required this.onSave,
    this.onDelete,
    this.creationTime,
    this.document,
    this.hidden = false,
  });
  final DateTime? creationTime;
  final ParchmentDocument? document;
  final bool hidden;
  final Future<void> Function(JournalEntryCompanion entry) onSave;
  final Future<void> Function()? onDelete;

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();

  static Future<void> newEntry({
    required BuildContext context,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return JournalEntryForm(
          onSave: (entry) async {
            await MyDatabase.instance
                .into(MyDatabase.instance.journalEntry)
                .insert(entry);
          },
        );
      },
    );
  }

  static Future<void> editEntry({
    required BuildContext context,
    required JournalEntryData journalEntry,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return JournalEntryForm(
          creationTime: journalEntry.creationTime,
          document: journalEntry.document,
          hidden: journalEntry.hidden,
          onDelete: () async {
            await (MyDatabase.instance.delete(MyDatabase.instance.journalEntry)
                  ..where((tbl) => tbl.id.equals(journalEntry.id)))
                .go();
          },
          onSave: (editedData) async {
            await (MyDatabase.instance.update(MyDatabase.instance.journalEntry)
                  ..where((tbl) => tbl.id.equals(journalEntry.id)))
                .write(editedData);
          },
        );
      },
    );
  }
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late final _controller = FleatherController(
    document: widget.document,
  );
  late DateTime _selectedDate =
      widget.creationTime?.toLocal() ?? DateTime.now();

  late var _hidden = widget.hidden;

  bool get isEmpty => _controller.document.toPlainText().trim().isEmpty;

  Future<void> _saveEntry() async {
    await widget.onSave(
      JournalEntryCompanion(
        creationTime: drift.Value(_selectedDate),
        document: drift.Value(_controller.document),
        hidden: drift.Value(_hidden),
      ),
    );
  }

  Future<void> _saveEntryAndPop() async {
    if (isEmpty) {
      // If it is empty, don't save and pop
      Navigator.of(context).pop();
      return;
    } else {
      // If it is not empty, save and pop
      _saveEntry();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _deleteEntry() async {
    if (widget.onDelete != null) {
      await widget.onDelete!();
    }
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: JournalDate(creationTime: _selectedDate),
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              currentDate: _selectedDate,
              initialEntryMode: DatePickerEntryMode.calendar,
              firstDate: DateTime(_selectedDate.year - 20),
              lastDate: DateTime(_selectedDate.year + 20),
            );
            if (selectedDate != null && context.mounted) {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_selectedDate),
              );
              if (selectedTime != null) {
                DateTime selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                setState(() {
                  _selectedDate = selectedDateTime;
                });
              }
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: widget.onDelete != null ? _deleteEntry : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: _saveEntryAndPop,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) async {
          if (isEmpty) {
            AppLogger.instance.i("Popping allowed since text is empty");
          } else {
            await _saveEntry();
            AppLogger.instance.i("Saving this entry");
          }
        },
        child: Column(
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
      ),
    );
  }
}
