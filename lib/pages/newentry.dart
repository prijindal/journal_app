import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../components/confirmation_dialog.dart';
import '../components/journal_date.dart';
import '../components/tag_selection.dart';
import '../helpers/theme.dart';
import '../models/core.dart';
import '../models/drift.dart';

@RoutePage()
class NewEntryScreen extends StatelessWidget {
  const NewEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JournalEntryForm(
      onSave: (entry) async {
        await MyDatabase.instance
            .into(MyDatabase.instance.journalEntry)
            .insert(entry);
      },
    );
  }
}

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
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late final _controller = FleatherController(
    document: widget.document == null
        ? null
        : ParchmentDocument.fromDelta(widget.document!.toDelta()),
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

  bool _canPopWithoutConfirmation() {
    if (isEmpty) {
      // When current document is empty, we can pop
      return true;
    }
    if (widget.document != null && widget.creationTime != null) {
      // When current and previous document are same, we can pop safely
      final documentEqual = widget.document!
              .toString()
              .compareTo(_controller.document.toString()) ==
          0;
      final dateEqual = widget.creationTime!.compareTo(_selectedDate) == 0;
      if (documentEqual && dateEqual) {
        return true;
      }
    }
    return false;
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
            onPressed: () async {
              if (!isEmpty) {
                await _saveEntry();
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          if (_canPopWithoutConfirmation()) {
            Navigator.of(context).pop();
            return;
          }
          final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmationDialog(
                  content: "Discard all the changes?",
                ),
              ) ??
              false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
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
