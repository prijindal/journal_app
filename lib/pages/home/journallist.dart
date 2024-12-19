import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/journal_list.dart';
import '../../models/core.dart';
import '../../models/local_state.dart';
import '../details.dart';

const mediaBreakpoint = 700;

@RoutePage()
class JournalListScreen extends StatelessWidget {
  const JournalListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > mediaBreakpoint) {
          return DesktopJournalListScreen();
        } else {
          return MobileJournalListScreen();
        }
      },
    );
  }
}

class DesktopJournalListScreen extends StatelessWidget {
  const DesktopJournalListScreen({
    super.key,
  });

  Widget _buildRightHandWidget(String? selectedEntryId) {
    if (selectedEntryId != null) {
      return Expanded(
        child: JourneyDetailsViewWrapper(
          key: Key("JourneyDetailsViewWrapper$selectedEntryId"),
          entryId: selectedEntryId,
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
    return Consumer<LocalStateNotifier>(
      builder: (_, localState, __) => Flex(
        direction: Axis.horizontal,
        children: [
          SizedBox(
            width: mediaBreakpoint / 2,
            child: JournalListWrapper(
              key: Key("JournalListWrapper${localState.showHidden}"),
              showHidden: localState.showHidden,
              selectedEntries: localState.selectedEntries,
              onSelectedEntriesChange: (newEntries) {
                localState.setSelectedEntries(newEntries);
              },
              onTap: (journalEntry) {
                localState.setSelectedEntryId(journalEntry.id);
              },
            ),
          ),
          _buildRightHandWidget(localState.selectedEntryId),
        ],
      ),
    );
  }
}

class MobileJournalListScreen extends StatelessWidget {
  const MobileJournalListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalStateNotifier>(
      builder: (_, localState, __) => JournalListWrapper(
        key: Key("JournalListWrapper${localState.showHidden}"),
        showHidden: localState.showHidden,
        selectedEntries: localState.selectedEntries,
        onSelectedEntriesChange: (newEntries) {
          localState.setSelectedEntries(newEntries);
        },
        onTap: (JournalEntryData journalEntry) {
          AutoRouter.of(context).pushNamed(
              "/details?entryId=${journalEntry.id}&showHidden=${localState.showHidden}");
        },
      ),
    );
  }
}
