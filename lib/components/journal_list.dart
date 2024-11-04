import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../models/core.dart';
import '../pages/newentry.dart';
import 'journal_date.dart';

class JournalList extends StatelessWidget {
  const JournalList({
    super.key,
    required this.entries,
  });

  final List<JournalEntryData>? entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      itemCount: (entries != null && entries!.isNotEmpty) ? entries!.length : 1,
      itemBuilder: (BuildContext context, int index) {
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
        final journalEntry = entries![index];
        return JournalEntryContainerTile(
          key: Key("${journalEntry.id}-tile"),
          journalEntry: journalEntry,
        );
      },
    );
  }
}

class JournalEntryContainerTile extends StatelessWidget {
  const JournalEntryContainerTile({
    super.key,
    required this.journalEntry,
  });
  final JournalEntryData journalEntry;

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
        child: ListTile(
          subtitle: FleatherEditor(
            readOnly: true,
            showCursor: false,
            enableInteractiveSelection: false,
            controller: FleatherController(
              document: displayDocument,
            ),
          ),
          title: JournalDate(creationTime: journalEntry.creationTime),
          onTap: () {
            JournalEntryForm.editEntry(
              context: context,
              journalEntry: journalEntry,
            );
          },
        ),
      ),
    );
  }
}
