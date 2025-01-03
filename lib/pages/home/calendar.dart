import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/calendars.dart';
import '../../helpers/db_watchers.dart';
import '../../models/core.dart';
import '../../models/local_state.dart';

@RoutePage()
class JournalCalendarScreen extends StatelessWidget {
  const JournalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LocalStateNotifier, bool>(
      selector: (_, localState) => localState.showHidden,
      builder: (context, showHidden, _) => JournalCalendarWrapper(
        key: Key("JournalCalendarScreen$showHidden"),
        showHidden: showHidden,
      ),
    );
  }
}

class JournalCalendarWrapper extends StatelessWidget {
  const JournalCalendarWrapper({
    super.key,
    required this.showHidden,
    this.searchText,
  });

  final String? searchText;
  final bool showHidden;

  Widget _build(BuildContext context, List<JournalEntryData>? journalEntries) {
    if (journalEntries == null) {
      return const Center(
        key: Key("JournalCalendarLoading"),
        child: Text(
          "Loading...",
        ),
      );
    }
    return JournalCalendar(
      entries: journalEntries,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JournalEntryData>>(
      stream: journalListSubscribe(
        showHidden: showHidden,
        searchText: searchText,
      ),
      builder: (context, journalEntries) => _build(
        context,
        journalEntries.data,
      ),
    );
  }
}
