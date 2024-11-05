import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../models/core.dart';
import '../pages/newentry.dart';
import 'journal_date.dart';

class JournalList extends StatelessWidget {
  const JournalList({
    super.key,
    required this.entries,
    this.selectedEntries = const [],
    this.onSelectedEntriesChange,
  });

  final List<JournalEntryData>? entries;
  final List<String> selectedEntries;
  final void Function(List<String>)? onSelectedEntriesChange;

  void _toggleSelected(JournalEntryData journalEntry) {
    final entries = selectedEntries;
    if (entries.contains(journalEntry.id)) {
      entries.remove(journalEntry.id);
    } else {
      entries.add(journalEntry.id);
    }
    if (onSelectedEntriesChange != null) {
      onSelectedEntriesChange!(entries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entries == null) {
      return const Center(
        key: Key("JournalListLoading"),
        child: Text(
          "Loading...",
        ),
      );
    }
    if (entries!.isEmpty) {
      return const Center(
        key: Key("JournalListEmpty"),
        child: Text(
          "No Journals added",
        ),
      );
    }
    return GroupedListView<JournalEntryData, String>(
      elements: entries!,
      groupBy: (element) => (DateFormat("MMM y").format(element.creationTime)),
      groupSeparatorBuilder: (String groupByValue) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(groupByValue),
        ],
      ),
      itemBuilder: (BuildContext context, JournalEntryData journalEntry) {
        return JournalEntryContainerTile(
          key: Key("${journalEntry.id}-tile"),
          journalEntry: journalEntry,
          selected: selectedEntries.contains(journalEntry.id),
          onTap: selectedEntries.isEmpty
              ? () {
                  JournalEntryForm.editEntry(
                    context: context,
                    journalEntry: journalEntry,
                  );
                }
              : () {
                  _toggleSelected(journalEntry);
                },
          onSelect: () {
            _toggleSelected(journalEntry);
          },
        );
      },
    );
  }
}

class JournalEntryContainerTile extends StatelessWidget {
  const JournalEntryContainerTile({
    super.key,
    required this.journalEntry,
    required this.onSelect,
    required this.selected,
    required this.onTap,
  });
  final JournalEntryData journalEntry;
  final VoidCallback onSelect;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final firstLine = journalEntry.document.lookupLine(0);
    final displayDocument = firstLine.node != null
        ? ParchmentDocument.fromDelta(firstLine.node!.toDelta())
        : journalEntry.document;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Card(
        elevation: selected ? 2 : 1,
        child: ListTile(
          selected: selected,
          subtitle: FleatherEditor(
            readOnly: true,
            showCursor: false,
            enableInteractiveSelection: false,
            controller: FleatherController(
              document: displayDocument,
            ),
          ),
          // TODO: Add hidden indicator
          title: JournalDate(creationTime: journalEntry.creationTime),
          onTap: onTap,
          onLongPress: onSelect,
        ),
      ),
    );
  }
}
