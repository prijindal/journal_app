import 'package:drift/drift.dart' as drift;
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../components/confirmation_dialog.dart';
import '../components/journal_date.dart';
import '../components/tag_selection.dart';
import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/core.dart';
import '../models/drift.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({
    super.key,
    required this.onSave,
    this.onDelete,
    this.creationTime,
    this.hidden = false,
    this.tags,
    this.document,
  });
  final DateTime? creationTime;
  final List<String>? tags;
  final ParchmentDocument? document;
  final bool hidden;
  final Future<void> Function(JournalEntryCompanion entry) onSave;
  final Future<bool> Function()? onDelete;

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();

  static Future<void> newEntry({
    required BuildContext context,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => JournalEntryForm(
          onSave: (entry) async {
            await MyDatabase.instance
                .into(MyDatabase.instance.journalEntry)
                .insert(entry);
          },
        ),
      ),
    );
  }

  static Future<void> editEntry({
    required BuildContext context,
    required JournalEntryData journalEntry,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => JournalEntryForm(
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
        ),
      ),
    );
  }
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late final _controller = FleatherController(
    document: widget.document,
  );
  late DateTime _selectedDate =
      widget.creationTime?.toLocal() ?? DateTime.now();
  late List<String> _tags = widget.tags ?? [];
  late bool _hidden = widget.hidden;

  bool get isEmpty => _controller.document.toPlainText().trim().isEmpty;

  Future<void> _saveEntry() async {
    await widget.onSave(
      JournalEntryCompanion(
        creationTime: drift.Value(_selectedDate),
        document: drift.Value(_controller.document),
        hidden: drift.Value(_hidden),
        tags: drift.Value(_tags),
      ),
    );
  }

  Future<void> _deleteEntry() async {
    bool deleted = false;
    if (widget.onDelete != null) {
      deleted = await widget.onDelete!();
    }
    if (context.mounted && deleted) {
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
              DateTime selectedDateTime = selectedDate;
              if (selectedTime != null) {
                selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
              }
              setState(() {
                _selectedDate = selectedDateTime;
              });
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: widget.onDelete != null ? _deleteEntry : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
                  Icons.tag,
                  false,
                  () async {
                    final changedTags = await showDialog<List<String>>(
                      context: context,
                      builder: (context) => TagSelection(
                        selectedTags: _tags,
                      ),
                    );
                    if (changedTags != null) {
                      setState(() {
                        _tags = changedTags;
                      });
                    }
                  },
                ),
                defaultToggleStyleButtonBuilder(
                  context,
                  ParchmentAttribute.code,
                  _hidden ? Icons.visibility_off : Icons.visibility,
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
                  color: ThemeDataWrapper.of(context).dividerColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
