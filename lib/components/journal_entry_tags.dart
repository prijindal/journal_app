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
    return Row(
      children: [
        if (journalEntry.hidden)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0.0,
              0,
              8.0,
              0,
            ),
            child: Icon(
              Icons.visibility_off,
              size: 20,
            ),
          ),
        ...journalEntry.tags.map<Widget>(
          (a) => Padding(
            padding: const EdgeInsets.fromLTRB(
              0.0,
              0,
              8.0,
              0,
            ),
            child: Text('#$a'),
          ),
        )
      ],
    );
  }
}
