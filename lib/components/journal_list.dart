import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../models/core.dart';
import '../pages/details.dart';
import 'journal_entry_tile.dart';

class JournalList extends StatelessWidget {
  const JournalList({
    super.key,
    required this.entries,
    required this.showHidden,
    this.selectedEntries = const [],
    this.onSelectedEntriesChange,
  });

  final List<JournalEntryData>? entries;
  final List<String> selectedEntries;
  final bool showHidden;
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
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => DetailsScreen(
                        entryId: journalEntry.id,
                        showHidden: showHidden,
                      ),
                    ),
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
