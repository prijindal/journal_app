import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/main_app_bar.dart';
import '../../helpers/logger.dart';
import '../../models/local_state.dart';
import '../settings/backup/firebase/firebase_sync.dart';
import 'calendar.dart';
import 'journallist.dart';

const mediaBreakpoint = 700;

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocalStateNotifier>(
      create: (context) => LocalStateNotifier(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    Timer(
      const Duration(seconds: 5),
      _checkLoginAndSyncDb,
    );
    super.initState();
  }

  Future<void> _syncDb() async {
    try {
      await syncDbToFirebase();
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
      final user = await getFirebaseUser();
      if (user != null) {
        await _syncDb();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Please setup backup to allow sync"),
              action: SnackBarAction(
                label: "Backup",
                onPressed: () async {
                  await AutoRouter.of(context).pushNamed("/settings/backup");
                },
              ),
            ),
          );
        }
      }
    }
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
      const JournalListScreen(),
      const JournalCalendarScreen(),
    ].elementAt(_currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
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
