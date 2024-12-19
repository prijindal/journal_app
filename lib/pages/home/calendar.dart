import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../components/calendars.dart';
import '../../helpers/db_watchers.dart';
import '../../models/core.dart';

@RoutePage()
class JournalCalendarScreen extends StatefulWidget {
  const JournalCalendarScreen({
    super.key,
    required this.showHidden,
    this.searchText,
  });

  final String? searchText;
  final bool showHidden;

  @override
  State<JournalCalendarScreen> createState() => _JournalCalendarScreenState();
}

class _JournalCalendarScreenState extends State<JournalCalendarScreen> {
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;

  @override
  void initState() {
    _addWatcher();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _addWatcher() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    _subscription = journalListSubscribe(
      showHidden: widget.showHidden,
      searchText: widget.searchText,
      listen: (event) {
        setState(() {
          _journalEntries = event;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_journalEntries == null) {
      return const Center(
        key: Key("JournalCalendarLoading"),
        child: Text(
          "Loading...",
        ),
      );
    }
    return JournalCalendar(
      entries: _journalEntries!,
    );
  }
}
