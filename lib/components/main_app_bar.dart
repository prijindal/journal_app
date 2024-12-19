import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../models/drift.dart';
import '../models/local_state.dart';
import '../models/settings.dart';
import '../pages/details.dart';
import 'confirmation_dialog.dart';
import 'pin_lock.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Selector<LocalStateNotifier, bool>(
      builder: (context, selectedEntriesEmpty, _) => selectedEntriesEmpty
          ? const MainAppBar()
          : const SelectedEntriesAppBar(),
      selector: (_, localState) => localState.selectedEntries.isEmpty,
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
  });

  Future<void> _toggleHidden(
    HiddenLockedMode currentLockedMode,
    BuildContext context,
  ) async {
    final localStateNotifier =
        Provider.of<LocalStateNotifier>(context, listen: false);
    final newValue = !localStateNotifier.showHidden;
    if (newValue) {
      if (currentLockedMode == HiddenLockedMode.biometrics) {
        // If encryption mode is biometrics, authenticate
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
      } else if (currentLockedMode == HiddenLockedMode.pin) {
        final successAuth = await PinLockScreen.verifyPin(context);
        if (!successAuth) {
          AppLogger.instance.i("Authentication failed");
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid pin, can't authenticate"),
            ),
          );
          return;
        }
      }
    }
    localStateNotifier.setShowHidden(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final localStateNotifier = Provider.of<LocalStateNotifier>(context);
    return AppBar(
      title: const Text("Journals"),
      actions: [
        IconButton(
          onPressed: () {
            AutoRouter.of(context).pushNamed(
                "/search?showHidden=${localStateNotifier.showHidden}");
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        Selector<SettingsStorageNotifier, HiddenLockedMode>(
          builder: (context, currentLockedMode, _) => IconButton(
            onPressed: () => _toggleHidden(currentLockedMode, context),
            icon: Icon(
              localStateNotifier.showHidden
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
          selector: (_, settingsStorage) =>
              settingsStorage.getHiddenLockedMode(),
        ),
        if (localStateNotifier.selectedEntryId != null)
          ...DetailsScreen.detailsIcons(
              localStateNotifier.selectedEntryId!, context),
        IconButton(
          onPressed: () {
            AutoRouter.of(context).pushNamed("/settings");
          },
          icon: const Icon(
            Icons.settings,
            size: 26.0,
          ),
        ),
      ],
    );
  }
}

class SelectedEntriesAppBar extends StatelessWidget {
  const SelectedEntriesAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localStateNotifier = Provider.of<LocalStateNotifier>(context);
    return AppBar(
      leading: IconButton(
        onPressed: () {
          localStateNotifier.setSelectedEntries([]);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text("${localStateNotifier.selectedEntries.length} Selected"),
      actions: [
        IconButton(
          onPressed: () async {
            final journalEntries =
                await (MyDatabase.instance.journalEntry.selectOnly()
                      ..addColumns([MyDatabase.instance.journalEntry.id]))
                    .get();
            if (localStateNotifier.selectedEntries.length <
                journalEntries.length) {
              // Select all entries
              localStateNotifier.setSelectedEntries(journalEntries
                  .map<String>(
                      (a) => a.read(MyDatabase.instance.journalEntry.id)!)
                  .toList());
            } else {
              // Unselect all entries
              localStateNotifier.setSelectedEntries([]);
            }
          },
          icon: Icon(Icons.select_all),
        ),
        IconButton(
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(),
            );
            if (shouldDelete != null && shouldDelete) {
              await MyDatabase.instance.journalEntry.deleteWhere(
                  (tbl) => tbl.id.isIn(localStateNotifier.selectedEntries));
              localStateNotifier.setSelectedEntries([]);
            }
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}
