import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../components/journal_list.dart';
import '../helpers/logger.dart';
import '../helpers/sync.dart';
import '../models/core.dart';
import '../models/drift.dart';
import 'newentry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;
  bool _showHidden = false;

  @override
  void initState() {
    _addWatcher();
    Timer(
      const Duration(seconds: 5),
      _checkLoginAndSyncDb,
    );
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

  Future<void> _syncDb() async {
    try {
      await syncDb();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sync successfully"),
          ),
        );
      }
    } catch (e, stack) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              parseErrorToString(e, stack, "Error while syncing"),
            ),
          ),
        );
      }
    }
  }

  Future<void> _checkLoginAndSyncDb() async {
    final isInitialized = isFirebaseInitialized();
    if (isInitialized) {
      final user = await getUser();
      if (user != null) {
        await _syncDb();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Please login to allow sync"),
              action: SnackBarAction(
                label: "Login",
                onPressed: () async {
                  await Navigator.pushNamed(context, "/login");
                  await _syncDb();
                },
              ),
            ),
          );
        }
      }
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Journals"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/search");
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _showHidden = !_showHidden;
            });
            _addWatcher();
          },
          icon: Icon(
            _showHidden ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings");
          },
          icon: const Icon(
            Icons.settings,
            size: 26.0,
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
    return JournalList(entries: _journalEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _checkLoginAndSyncDb,
        child: _buildJournalList(),
      ),
      floatingActionButton: _buildFab(),
    );
  }
}
