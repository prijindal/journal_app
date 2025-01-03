import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../helpers/db_watchers.dart';
import '../models/core.dart';
import 'journal_entry_tile.dart';

class JournalListWrapper extends StatelessWidget {
  const JournalListWrapper({
    super.key,
    required this.showHidden,
    this.searchText,
    required this.onTap,
    this.selectedEntries = const [],
    this.onSelectedEntriesChange,
  });

  final String? searchText;
  final bool showHidden;
  final List<String> selectedEntries;
  final void Function(JournalEntryData) onTap;
  final void Function(List<String>)? onSelectedEntriesChange;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JournalEntryData>>(
      stream: journalListSubscribe(
        showHidden: showHidden,
        searchText: searchText,
      ),
      builder: (context, journalEntries) {
        return JournalList(
          entries: journalEntries.data,
          onTap: onTap,
          onSelectedEntriesChange: onSelectedEntriesChange,
          selectedEntries: selectedEntries,
        );
      },
    );
  }
}

class JournalList extends StatelessWidget {
  const JournalList({
    super.key,
    required this.entries,
    required this.onTap,
    this.selectedEntries = const [],
    this.onSelectedEntriesChange,
  });

  final List<JournalEntryData>? entries;
  final List<String> selectedEntries;
  final void Function(JournalEntryData) onTap;
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
    return GroupedListView<JournalEntryData, DateTime>(
      elements: entries!,
      groupComparator: (a, b) {
        return -a.compareTo(b);
      },
      groupBy: (element) {
        return DateTime(
          element.creationTime.year,
          element.creationTime.month,
        );
      },
      groupSeparatorBuilder: (DateTime groupByValue) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat("MMM y").format(groupByValue)),
        ],
      ),
      itemBuilder: (BuildContext context, JournalEntryData journalEntry) {
        return JournalEntryContainerTile(
          key: Key("${journalEntry.id}-tile"),
          journalEntry: journalEntry,
          selected: selectedEntries.contains(journalEntry.id),
          onTap: selectedEntries.isEmpty
              ? () => onTap(journalEntry)
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
