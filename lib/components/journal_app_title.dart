import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/core.dart';
import 'journal_entry_tags.dart';

class JournalAppTitle extends StatelessWidget {
  const JournalAppTitle({
    super.key,
    required this.journalEntry,
  });

  final JournalEntryData journalEntry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat("d MMM y | E").format(journalEntry.creationTime)),
            Text(
              DateFormat.jm().format(journalEntry.creationTime),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 8.0,
          ),
          child: JournalEntryTags(journalEntry: journalEntry),
        ),
      ],
    );
  }
}
