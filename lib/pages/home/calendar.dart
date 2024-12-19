import 'dart:async';

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

class JournalCalendarWrapper extends StatefulWidget {
  const JournalCalendarWrapper({
    super.key,
    required this.showHidden,
    this.searchText,
  });

  final String? searchText;
  final bool showHidden;

  @override
  State<JournalCalendarWrapper> createState() => _JournalCalendarWrapperState();
}

class _JournalCalendarWrapperState extends State<JournalCalendarWrapper> {
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
