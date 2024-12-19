import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/journal_entry_form.dart';
import '../models/drift.dart';

@RoutePage()
class NewEntryScreen extends StatelessWidget {
  const NewEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JournalEntryForm(
      onSave: (entry) async {
        await MyDatabase.instance
            .into(MyDatabase.instance.journalEntry)
            .insert(entry);
      },
    );
  }
}
