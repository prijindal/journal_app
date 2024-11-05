import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/core.dart';
import '../pages/newentry.dart';
import 'journal_entry_tile.dart';

class JournalCalendar extends StatefulWidget {
  const JournalCalendar({
    super.key,
    required this.entries,
  });

  final List<JournalEntryData> entries;

  @override
  State<JournalCalendar> createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<JournalCalendar> {
  late DateTime _focusedDay = _lastDay;
  CalendarFormat _calendarformat = CalendarFormat.month;

  List<DateTime> _firstAndLast() {
    final entries = List<JournalEntryData>.from(widget.entries)
      ..sort((a, b) {
        return a.creationTime.difference(b.creationTime).inSeconds;
      });
    return [
      entries.firstOrNull?.creationTime.toLocal() ??
          (DateTime.now().subtract(const Duration(days: 1))),
      entries.lastOrNull?.creationTime.toLocal() ??
          (DateTime.now().add(const Duration(days: 1))),
    ];
  }

  DateTime get _firstDay {
    return _firstAndLast()[0];
  }

  DateTime get _lastDay {
    return _firstAndLast()[1];
  }

  List<JournalEntryData> _getEventsForDay(DateTime day) {
    return widget.entries
        .where((element) => isSameDay(day, element.creationTime.toLocal()))
        .toList();
  }

  Widget _buildCalendar() {
    return TableCalendar<void>(
      calendarFormat: _calendarformat,
      onFormatChanged: (calendarFormat) {
        setState(() {
          _calendarformat = calendarFormat;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) {
        return _getEventsForDay(day);
      },
      selectedDayPredicate: (day) {
        return isSameDay(_focusedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        weekendStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.inverseSurface,
          fontSize: 16.0,
        ),
      ),
      currentDay: _focusedDay,
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
    );
  }

  Widget _buildEvents(List<JournalEntryData> entries) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      itemCount: entries.isNotEmpty ? entries.length : 1,
      itemBuilder: (BuildContext context, int index) {
        if (entries.isEmpty) {
          return const ListTile(title: Text("No Entry"));
        }
        final entry = entries[index];
        return JournalEntryContainerTile(
          journalEntry: entry,
          onTap: () => {
            JournalEntryForm.editEntry(
              context: context,
              journalEntry: entry,
            )
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(),
        const SizedBox(height: 8.0),
        _buildEvents(_getEventsForDay(_focusedDay)),
      ],
    );
  }
}
