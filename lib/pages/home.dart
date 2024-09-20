import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../models/core.dart';
import '../models/drift.dart';
import 'newentry.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;
  bool _showHidden = false;

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
    final query = MyDatabase.instance.journalEntry.select();
    if (!_showHidden) {
      query.where((tbl) => tbl.hidden.equals(false));
    }
    _subscription = (query
          ..orderBy(
            [
              (t) => OrderingTerm(
                    expression: t.creationTime,
                    mode: OrderingMode.desc,
                  ),
            ],
          ))
        .watch()
        .listen((event) {
      setState(() {
        _journalEntries = event;
      });
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Journals"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showHidden = !_showHidden;
              });
              _addWatcher();
            },
            child: Icon(
              _showHidden ? Icons.visibility : Icons.visibility_off,
              size: 26.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
            child: const Icon(
              Icons.person,
              size: 26.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FloatingActionButton(
          onPressed: _recordJournalEntry,
          tooltip: 'New Journal',
          child: const Icon(Icons.add),
        );
      },
    );
  }

  void _recordJournalEntry() {
    JournalEntryForm.newEntry(
      context: context,
    );
  }

  Widget _buildJournalList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      itemCount: _journalEntries != null ? _journalEntries!.length : 1,
      itemBuilder: (BuildContext context, int index) {
        if (_journalEntries == null) {
          return const Center(
            key: Key("JournalListLoading"),
            child: Text(
              "Loading...",
            ),
          );
        }
        if (_journalEntries!.isEmpty) {
          return const Center(
            key: Key("JournalListEmpty"),
            child: Text(
              "No Journals added",
            ),
          );
        }
        final journalEntry = _journalEntries![index];
        return JournalEntryContainerTile(
          key: Key("${journalEntry.id}-tile"),
          journalEntry: journalEntry,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildJournalList(),
      floatingActionButton: _buildFab(),
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
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 0,
      ),
      child: Card(
        child: ListTile(
          subtitle: FleatherEditor(
            readOnly: true,
            showCursor: false,
            enableInteractiveSelection: false,
            controller: FleatherController(
              document: ParchmentDocument.fromJson(
                jsonDecode(journalEntry.description) as List<dynamic>,
              ),
            ),
          ),
          title: Text(
            journalEntry.creationTime.toString(),
          ),
          onTap: () {
            JournalEntryForm.editEntry(
              context: context,
              journalEntry: journalEntry,
            );
          },
        ),
      ),
    );
  }
}
