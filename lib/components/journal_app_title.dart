import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/core.dart';

class JournalAppTitle extends StatelessWidget {
  const JournalAppTitle({
    super.key,
    required this.journalEntry,
  });

  final JournalEntryData journalEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat("d MMM y | E").format(journalEntry.creationTime)),
        Text(
          DateFormat.jm().format(journalEntry.creationTime),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
