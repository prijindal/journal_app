import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../models/core.dart';
import 'journal_date.dart';

class JournalEntryContainerTile extends StatelessWidget {
  const JournalEntryContainerTile({
    super.key,
    required this.journalEntry,
    this.onSelect,
    this.selected = false,
    required this.onTap,
  });
  final JournalEntryData journalEntry;
  final VoidCallback? onSelect;
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
          title: JournalDate(creationTime: journalEntry.creationTime),
          subtitle: Column(
            children: [
              FleatherEditor(
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                controller: FleatherController(
                  document: displayDocument,
                ),
              ),
              Row(
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
              )
            ],
          ),
          onTap: onTap,
          onLongPress: onSelect,
        ),
      ),
    );
  }
}
