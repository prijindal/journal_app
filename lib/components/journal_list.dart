import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../models/core.dart';
import '../models/drift.dart';
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
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
            MenuAnchor(
              alignmentOffset: Offset.fromDirection(0, -80),
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_horiz),
                  tooltip: 'Show menu',
                );
              },
              menuChildren: [
                MenuItemButton(
                  child: Text("Edit"),
                  onPressed: () {
                    JournalEntryForm.editEntry(
                      context: context,
                      journalEntry: journalEntry,
                    );
                  },
                ),
                // TODO: Implement hidden
                // MenuItemButton(
                //   child: Text("Mark as hidden"),
                //   onPressed: () {},
                // ),
                MenuItemButton(
                  child: Text("Delete"),
                  onPressed: () async {
                    // TODO: Implement Confirmation dialog
                    await (MyDatabase.instance
                            .delete(MyDatabase.instance.journalEntry)
                          ..where((tbl) => tbl.id.equals(journalEntry.id)))
                        .go();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
