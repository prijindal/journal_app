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
    required this.showHidden,
    required this.selectedEntries,
    required this.selectedEntryId,
    required this.onSetSelectedEntryIndex,
    required this.onSelectedEntriesChange,
  });

  final bool showHidden;
  final List<String> selectedEntries;
  final String? selectedEntryId;
  final void Function(List<String>)? onSelectedEntriesChange;
  final void Function(String?) onSetSelectedEntryIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > mediaBreakpoint) {
          return DesktopJournalListScreen(
            showHidden: showHidden,
            selectedEntries: selectedEntries,
            onSelectedEntriesChange: onSelectedEntriesChange,
            onSetSelectedEntryIndex: onSetSelectedEntryIndex,
            selectedEntryId: selectedEntryId,
          );
        } else {
          return MobileJournalListScreen(
            showHidden: showHidden,
            selectedEntries: selectedEntries,
            onSelectedEntriesChange: onSelectedEntriesChange,
          );
        }
      },
    );
  }
}

class DesktopJournalListScreen extends StatelessWidget {
  const DesktopJournalListScreen({
    super.key,
    required this.showHidden,
    required this.selectedEntryId,
    required this.selectedEntries,
    required this.onSelectedEntriesChange,
    required this.onSetSelectedEntryIndex,
  });

  final bool showHidden;
  final List<String> selectedEntries;
  final String? selectedEntryId;
  final void Function(List<String> p1)? onSelectedEntriesChange;
  final void Function(String? p1) onSetSelectedEntryIndex;

  Widget _buildRightHandWidget() {
    if (selectedEntryId != null) {
      return Expanded(
        child: JourneyDetailsViewWrapper(
          key: Key("JourneyDetailsViewWrapper$selectedEntryId"),
          entryId: selectedEntryId!,
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
    return Flex(
      direction: Axis.horizontal,
      children: [
        SizedBox(
          width: mediaBreakpoint / 2,
          child: JournalListWrapper(
            key: Key("JournalListWrapper$showHidden"),
            showHidden: showHidden,
            selectedEntries: selectedEntries,
            onSelectedEntriesChange: onSelectedEntriesChange,
            onTap: (journalEntry) {
              onSetSelectedEntryIndex(journalEntry.id);
            },
          ),
        ),
        _buildRightHandWidget(),
      ],
    );
  }
}

class MobileJournalListScreen extends StatelessWidget {
  const MobileJournalListScreen({
    super.key,
    required this.showHidden,
    required this.selectedEntries,
    required this.onSelectedEntriesChange,
  });

  final bool showHidden;
  final List<String> selectedEntries;
  final void Function(List<String> p1)? onSelectedEntriesChange;

  @override
  Widget build(BuildContext context) {
    return JournalListWrapper(
      key: Key("JournalListWrapper$showHidden"),
      showHidden: showHidden,
      selectedEntries: selectedEntries,
      onSelectedEntriesChange: onSelectedEntriesChange,
      onTap: (JournalEntryData journalEntry) {
        AutoRouter.of(context).pushNamed(
            "/details?entryId=${journalEntry.id}&showHidden=$showHidden");
      },
    );
  }
}
