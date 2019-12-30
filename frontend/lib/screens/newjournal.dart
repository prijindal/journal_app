import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';

import 'package:journal_app/api/api.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

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
        Navigator.of(context).popAndPushNamed("/journal");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JournalAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveJournal,
        child: Icon(Icons.save),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          constraints: BoxConstraints(
            maxWidth: 500.0,
          ),
          child: TextFormField(
            autofocus: true,
            controller: _contentController,
            minLines: 10,
            maxLines: 20,
          ),
        ),
      ),
    );
  }
}
