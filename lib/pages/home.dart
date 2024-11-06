import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../components/calendars.dart';
import '../components/confirmation_dialog.dart';
import '../components/journal_list.dart';
import '../helpers/logger.dart';
import '../helpers/sync.dart';
import '../models/core.dart';
import '../models/drift.dart';
import '../models/settings.dart';
import 'newentry.dart';
import 'search.dart';

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

  Future<void> _toggleHidden(HiddenEncryptionMode currentEncryptionMode) async {
    final newValue = !_showHidden;
    if (newValue) {
      if (currentEncryptionMode == HiddenEncryptionMode.biometrics) {
        final LocalAuthentication auth = LocalAuthentication();

        final authenticated = await auth.authenticate(
          localizedReason: "Biometrics scan for showing entries",
        );
        if (!authenticated) {
          AppLogger.instance
              .i("Biometrics authenticated failed, not changing values");
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Biometrics failed, can't authenticate"),
              ),
            );
          }
          return;
        }
      }
      // If encryption mode is biometrics, authenticate
    }
    setState(() {
      _showHidden = newValue;
    });
    _addWatcher();
  }

  AppBar _buildAppBar() {
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    final currentEncryptionMode = settingsStorage.getHiddenEncryptionMode();
    return AppBar(
      title: const Text("Journals"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => SearchScreen(
                  showHidden: _showHidden,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () => _toggleHidden(currentEncryptionMode),
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

  AppBar _buildSelectedEntriesAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            _selectedEntries = [];
          });
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text("${_selectedEntries.length} Selected"),
      actions: [
        IconButton(
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(),
            );
            if (shouldDelete != null && shouldDelete) {
              await MyDatabase.instance.journalEntry
                  .deleteWhere((tbl) => tbl.id.isIn(_selectedEntries));
              setState(() {
                _selectedEntries = [];
              });
            }
          },
          icon: Icon(Icons.delete),
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
          key: Key("New Journal"),
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
    return JournalList(
      entries: _journalEntries,
      selectedEntries: _selectedEntries,
      onSelectedEntriesChange: (entries) {
        setState(() {
          _selectedEntries = entries;
        });
      },
    );
  }

  Widget _buildJournalCalendar() {
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

  Widget _buildBody() {
    return [
      _buildJournalList(),
      _buildJournalCalendar(),
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
