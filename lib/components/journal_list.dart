import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../helpers/db_watchers.dart';
import '../models/core.dart';
import 'journal_entry_tile.dart';

class JournalListWrapper extends StatefulWidget {
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
  State<JournalListWrapper> createState() => _JournalListWrapperState();
}

class _JournalListWrapperState extends State<JournalListWrapper> {
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;

  @override
  void initState() {
    _addWatcher();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _addWatcher() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    _subscription = journalListSubscribe(
      showHidden: widget.showHidden,
      searchText: widget.searchText,
      listen: (event) {
        setState(() {
          _journalEntries = event;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return JournalList(
      entries: _journalEntries,
      onTap: widget.onTap,
      onSelectedEntriesChange: widget.onSelectedEntriesChange,
      selectedEntries: widget.selectedEntries,
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
