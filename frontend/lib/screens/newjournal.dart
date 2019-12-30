import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';

import 'package:journal_app/api/api.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/components/textarea.dart';

class NewJournalScreen extends StatefulWidget {
  _NewJournalScreenState createState() => _NewJournalScreenState();
}

class _NewJournalScreenState extends State<NewJournalScreen> {
  TextEditingController _contentController = TextEditingController();

  _saveJournal() async {
    final newjournal =
        await HttpApi.getInstance().newJournal(_contentController.text);
    if (newjournal != null) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed("/journal");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JournalAppDrawer(),
      appBar: JournalAppBar(
        title: "New Journal",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveJournal,
        child: Icon(Icons.save),
      ),
      body: JournalTextArea(
        controller: _contentController,
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
