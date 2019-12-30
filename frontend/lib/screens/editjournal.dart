import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';

import 'package:journal_app/api/api.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/components/textarea.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

class EditJournalScreenArguments {
  final Int64 id;

  EditJournalScreenArguments(this.id);
}

class EditJournalScreen extends StatefulWidget {
  final Journal journal;
  EditJournalScreen({this.journal});
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
        Navigator.of(context).pushReplacementNamed("/journal");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getContent();
  }

  Int64 _getId() {
    if (widget.journal == null) {
      final EditJournalScreenArguments args =
          ModalRoute.of(context).settings.arguments;
      return args.id;
    } else {
      return widget.journal.id;
    }
  }

  void _getContent() async {
    if (widget.journal == null) {
      await HttpApi.getInstance().getJournal();
      final journal = HttpApi.getInstance()
          .journalResponse
          .journals
          .singleWhere((journal) => journal.id == _getId());
      if (journal != null) {
        setState(() {
          _contentController = TextEditingController(text: journal.content);
        });
      }
    } else {
      setState(() {
        _contentController =
            TextEditingController(text: widget.journal.content);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JournalAppDrawer(),
      appBar: JournalAppBar(
        title: "Edit Journal",
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
