import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../components/main_app_bar.dart';
import '../../helpers/logger.dart';
import '../../helpers/sync.dart';
import '../../models/core.dart';
import '../../models/drift.dart';
import 'calendar.dart';
import 'journallist.dart';

const mediaBreakpoint = 700;

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;
  bool _showHidden = false;
  List<String> _selectedEntries = [];
  int _currentPageIndex = 0;
  int _selectedEntryIndex = -1;

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
                  await AutoRouter.of(context).pushNamed("/login");
                  await _syncDb();
                },
              ),
            ),
          );
        }
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return MainAppBar(
      journalEntries: _journalEntries,
      showHidden: _showHidden,
      onChangeHidden: (newValue) {
        setState(() {
          _showHidden = newValue;
        });
        _addWatcher();
      },
      selectedEntryIndex: _selectedEntryIndex,
    );
  }

  PreferredSizeWidget _buildSelectedEntriesAppBar() {
    return SelectedEntriesAppBar(
      journalEntries: _journalEntries,
      selectedEntries: _selectedEntries,
      onSelectedEntriesChange: (newEntries) {
        setState(() {
          _selectedEntries = newEntries;
        });
      },
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => AutoRouter.of(context).pushNamed("/newjournal"),
      tooltip: 'New Journal',
      key: Key("New Journal"),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody() {
    return [
      JournalListScreen(
        journalEntries: _journalEntries,
        showHidden: _showHidden,
        selectedEntries: _selectedEntries,
        selectedEntryIndex: _selectedEntryIndex,
        onSetSelectedEntryIndex: (index) {
          setState(() {
            _selectedEntryIndex = index;
          });
        },
        onSelectedEntriesChange: (entries) {
          setState(() {
            _selectedEntries = entries;
          });
        },
      ),
      JournalCalendarScreen(
        journalEntries: _journalEntries,
      ),
    ].elementAt(_currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedEntries.isEmpty
          ? _buildAppBar()
          : _buildSelectedEntriesAppBar(),
      body: RefreshIndicator(
        onRefresh: _checkLoginAndSyncDb,
        child: _buildBody(),
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'List',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
