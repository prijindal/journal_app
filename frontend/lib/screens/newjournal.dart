import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';

import 'package:journal_app/api/api.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/components/enterkey.dart';
import 'package:journal_app/components/textarea.dart';
import 'package:journal_app/helpers/encrypt.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pb.dart';
import 'package:pedantic/pedantic.dart';

class NewJournalScreen extends StatefulWidget {
  _NewJournalScreenState createState() => _NewJournalScreenState();
}

class _NewJournalScreenState extends State<NewJournalScreen> {
  TextEditingController _contentController = TextEditingController();

  _saveJournal() async {
    var saveType = getSaveType();
    var content = _contentController.text;
    if (saveType == Journal_JournalSaveType.ENCRYPTED) {
      if (EncryptionService.getInstance().encryptionKey == null) {
        await enterKeyModalAndSave(context);
        FlutterPersistor.getInstance()
            .setString(SAVE_TYPE, saveType.value.toString());
      }
      content = EncryptionService.getInstance().encrypt(content);
    }
    final newjournal =
        await HttpApi.getInstance().newJournal(content, saveType: saveType);
    if (newjournal != null) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        unawaited(Navigator.of(context).pushReplacementNamed("/journal"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JournalAppDrawer(),
      appBar: JournalAppBar(
        title: Text("New Journal"),
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
