import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/main_app_bar.dart';
import '../../models/local_state.dart';
import '../settings/backup/firebase/firebase_sync.dart';
import '../settings/backup/gdrive/gdrive_sync.dart';
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
      const Duration(seconds: 1),
      () => _initSync(),
    );
    Timer(
      const Duration(seconds: 3),
      () => _sync(),
    );
    super.initState();
  }

  Future<void> _initSync() async {
    // This is just to initialize firebase and gdrive sync after firebase init is called
    Provider.of<FirebaseSync>(context, listen: false);
    Provider.of<GdriveSync>(context, listen: false);
  }

  Future<void> _sync() async {
    final [firebaseSyncStatus, gDriveSyncStatus] = await Future.wait([
      Provider.of<FirebaseSync>(context, listen: false)
          .sync(context, suppressErrors: true),
      Provider.of<GdriveSync>(context, listen: false)
          .sync(context, suppressErrors: true),
    ]);
    if (firebaseSyncStatus == false && gDriveSyncStatus == false) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
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
      body: _buildBody(),
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
