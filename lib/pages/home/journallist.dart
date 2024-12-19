import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../components/journal_list.dart';
import '../../models/core.dart';
import '../details.dart';

const mediaBreakpoint = 700;

@RoutePage()
class JournalListScreen extends StatelessWidget {
  const JournalListScreen({
    super.key,
    required this.journalEntries,
    required this.showHidden,
    required this.selectedEntries,
    required this.selectedEntryIndex,
    required this.onSetSelectedEntryIndex,
    required this.onSelectedEntriesChange,
  });

  final List<JournalEntryData>? journalEntries;
  final bool showHidden;
  final List<String> selectedEntries;
  final int selectedEntryIndex;
  final void Function(List<String>)? onSelectedEntriesChange;
  final void Function(int) onSetSelectedEntryIndex;

  Widget _buildRightHandWidget() {
    if (journalEntries != null &&
        selectedEntryIndex >= 0 &&
        selectedEntryIndex < journalEntries!.length) {
      return Expanded(
        child: JourneyDetailsView(
          journalEntry: journalEntries![selectedEntryIndex],
        ),
      );
    } else {
      return Center(
        child: Text("Selet an entry on the left"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > mediaBreakpoint) {
          return Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: mediaBreakpoint / 2,
                child: JournalList(
                  entries: journalEntries,
                  showHidden: showHidden,
                  selectedEntries: selectedEntries,
                  onSelectedEntriesChange: onSelectedEntriesChange,
                  onTap: (journalEntry) {
                    onSetSelectedEntryIndex(journalEntries!
                        .indexWhere((a) => a.id == journalEntry.id));
                  },
                ),
              ),
              _buildRightHandWidget(),
            ],
          );
        } else {
          return JournalList(
            entries: journalEntries,
            showHidden: showHidden,
            selectedEntries: selectedEntries,
            onSelectedEntriesChange: onSelectedEntriesChange,
            onTap: (JournalEntryData journalEntry) {
              AutoRouter.of(context).pushNamed(
                  "/details?entryId=${journalEntry.id}&showHidden=$showHidden");
            },
          );
        }
      },
    );
  }
}
