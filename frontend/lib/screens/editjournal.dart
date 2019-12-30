import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';

import 'package:journal_app/components/appbar.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/components/textarea.dart';
import 'package:journal_app/helpers/encrypt.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

class EditJournalScreen extends StatefulWidget {
  final Journal journal;
  EditJournalScreen({this.journal});
  _EditJournalScreenState createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  TextEditingController _contentController = TextEditingController();

  _saveJournal() async {
    var content = _contentController.text;
    if (widget.journal.saveType == Journal_JournalSaveType.ENCRYPTED) {
      content = getEncryptor().encrypt(content).base64;
    }
    final savedJournal = await HttpApi.getInstance().saveJournal(
        widget.journal.id, content,
        saveType: widget.journal.saveType);
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

  void _getContent() async {
    var content = widget.journal.content;
    if (widget.journal.saveType == Journal_JournalSaveType.ENCRYPTED) {
      content = getEncryptor().decrypt(Encrypted.fromBase64(content));
    }
    setState(() {
      _contentController = TextEditingController(text: content);
    });
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
