import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../components/calendars.dart';
import '../../models/core.dart';

@RoutePage()
class JournalCalendarScreen extends StatelessWidget {
  const JournalCalendarScreen({
    super.key,
    required this.journalEntries,
  });

  final List<JournalEntryData>? journalEntries;

  @override
  Widget build(BuildContext context) {
    if (journalEntries == null) {
      return const Center(
        key: Key("JournalCalendarLoading"),
        child: Text(
          "Loading...",
        ),
      );
    }
    return JournalCalendar(
      entries: journalEntries!,
    );
  }
}
