import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../models/core.dart';
import '../models/drift.dart';
import '../models/settings.dart';
import '../pages/details.dart';
import 'confirmation_dialog.dart';
import 'pin_lock.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.journalEntries,
    required this.showHidden,
    required this.onChangeHidden,
    required this.selectedEntryIndex,
  });

  final bool showHidden;
  final void Function(bool) onChangeHidden;
  final List<JournalEntryData>? journalEntries;
  final int selectedEntryIndex;
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  Future<void> _toggleHidden(
      HiddenLockedMode currentLockedMode, BuildContext context) async {
    final newValue = !showHidden;
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
    onChangeHidden(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Journals"),
      actions: [
        IconButton(
          onPressed: () {
            AutoRouter.of(context).pushNamed("/search?showHidden=$showHidden");
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        Selector<SettingsStorageNotifier, HiddenLockedMode>(
          builder: (context, currentLockedMode, _) => IconButton(
            onPressed: () => _toggleHidden(currentLockedMode, context),
            icon: Icon(
              showHidden ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          selector: (_, settingsStorage) =>
              settingsStorage.getHiddenLockedMode(),
        ),
        if (journalEntries != null &&
            selectedEntryIndex >= 0 &&
            selectedEntryIndex < journalEntries!.length)
          ...DetailsScreen.detailsIcons(
              journalEntries![selectedEntryIndex], context),
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

class SelectedEntriesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SelectedEntriesAppBar({
    super.key,
    required this.journalEntries,
    required this.onSelectedEntriesChange,
    required this.selectedEntries,
  });

  final List<JournalEntryData>? journalEntries;
  final List<String> selectedEntries;
  final void Function(List<String>) onSelectedEntriesChange;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          onSelectedEntriesChange([]);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text("${selectedEntries.length} Selected"),
      actions: [
        IconButton(
          onPressed: () {
            if (selectedEntries.length < journalEntries!.length) {
              // Select all entries
              onSelectedEntriesChange(
                  journalEntries!.map<String>((a) => a.id).toList());
            } else {
              // Unselect all entries
              onSelectedEntriesChange([]);
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
              await MyDatabase.instance.journalEntry
                  .deleteWhere((tbl) => tbl.id.isIn(selectedEntries));
              onSelectedEntriesChange([]);
            }
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}
