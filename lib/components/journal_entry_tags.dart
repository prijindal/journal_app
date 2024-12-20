import 'package:flutter/material.dart';

import '../models/core.dart';

class JournalEntryTags extends StatelessWidget {
  const JournalEntryTags({
    super.key,
    required this.journalEntry,
  });

  final JournalEntryData journalEntry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        if (journalEntry.hidden)
          Icon(
            Icons.visibility_off,
            size: 20,
          ),
        ...journalEntry.tags.map<Widget>(
          (a) => Text('#$a'),
        )
      ],
    );
  }
}
