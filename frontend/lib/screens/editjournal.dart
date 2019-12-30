import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';

import 'package:journal_app/api/api.dart';

class EditJournalScreenArguments {
  final Int64 id;

  EditJournalScreenArguments(this.id);
}

class EditJournalScreen extends StatefulWidget {
  _EditJournalScreenState createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  TextEditingController _contentController = TextEditingController();

  _saveJournal() async {
    final savedJournal = await HttpApi.getInstance()
        .saveJournal(_getId(), _contentController.text);
    if (savedJournal != null) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).popAndPushNamed("/journal");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getContent();
  }

  Int64 _getId() {
    final EditJournalScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    return args.id;
  }

  void _getContent() async {
    final journalResponse = await HttpApi.getInstance().getJournal();
    final journal = journalResponse.journals
        .singleWhere((journal) => journal.id == _getId());
    if (journal != null) {
      setState(() {
        _contentController.text = journal.content;
      });
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
