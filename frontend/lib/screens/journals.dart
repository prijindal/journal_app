import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/components/enterkey.dart';
import 'package:journal_app/helpers/encrypt.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/screens/editjournal.dart';
import 'package:pedantic/pedantic.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:journal_app/api/api.dart';
import 'package:journal_app/protobufs/journal.pb.dart';

class JournalsScreen extends StatefulWidget {
  _JournalsScreenState createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _getJournals();
  }

  JournalResponse get _journalResponse => HttpApi.getInstance().journalResponse;

  Future<void> _getJournals() async {
    var _instance = HttpApi.getInstance();
    var _isConnected = await _instance.isConnected();
    if (!_isConnected) {
      return;
    }
    try {
      await _instance.getJournal();
    } catch (e) {
      await _instance.logout();
      await Navigator.of(context).pushReplacementNamed("/login");
      return;
    }
    if (_journalResponse == null) {
      unawaited(Navigator.of(context).pushReplacementNamed("/login"));
    } else {
      setState(() {});
    }
  }

  _goToNewJournal() {
    Navigator.of(context).pushNamed("/new").then((a) {
      _getJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JournalAppDrawer(),
      appBar: JournalAppBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: _goToNewJournal, child: Icon(Icons.add)),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _getJournals,
        child: _journalResponse == null
            ? Center(
                child: Text("Loading..."),
              )
            : _journalResponse.total == 0
                ? Center(
                    child: Text("No Journal entries found"),
                  )
                : ListView.builder(
                    itemCount: _journalResponse.journals.length,
                    itemBuilder: (context, index) => _JournalTile(
                      _journalResponse.journals[index],
                      onDelete: () => setState(() {}),
                      onEdit: () => setState(() {}),
                    ),
                  ),
      ),
    );
  }
}

class _JournalTile extends StatelessWidget {
  final Journal journal;
  @required
  final VoidCallback onDelete;
  @required
  final VoidCallback onEdit;
  _JournalTile(this.journal, {this.onDelete, this.onEdit});

  String _fromNow() {
    final date =
        DateTime.fromMillisecondsSinceEpoch(journal.createdAt.toInt() * 1000);
    return timeago.format(date);
  }

  _deleteJournal(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete Journal Entry ${journal.id}?"),
        content: const Text("Are you sure you want to delete?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete) {
      await HttpApi.getInstance().deleteJournal(journal.id);
      onDelete();
    }
  }

  _editJournal(BuildContext context) async {
    // EditJournalScreenArguments args = EditJournalScreenArguments(journal.id);
    // await Navigator.of(context).pushNamed('/edit', arguments: args);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJournalScreen(
          journal: journal,
        ),
      ),
    );
    onEdit();
  }

  String _getContent() {
    String content;
    if (journal.saveType != Journal_JournalSaveType.ENCRYPTED) {
      content = journal.content;
    } else {
      try {
        content = EncryptionService.getInstance().decrypt(journal.content);
      } catch (e) {
        EncryptionService.getInstance().deleteEncryptionKey();
        return 'Wrong Encryption key.Tap to enter again';
      }
    }
    return content.replaceAll("\n", " ");
  }

  bool _isEncryptionKeyNotFound() {
    if (journal.saveType == Journal_JournalSaveType.ENCRYPTED) {
      var encryptionKey = EncryptionService.getInstance().encryptionKey;
      if (encryptionKey == null || encryptionKey.isEmpty) {
        return true;
      }
      return false;
    }
    return false;
  }

  void _enterEncryptionKey(BuildContext context) async {
    final isSuccessful = await enterKeyModalAndSave(context);
    await FlutterPersistor.getInstance()
        .setString(SAVE_TYPE, journal.saveType.value.toString());
    if (isSuccessful) {
      onEdit();
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: _isEncryptionKeyNotFound() ? Icon(Icons.vpn_key) : null,
        title: Text(
          _isEncryptionKeyNotFound()
              ? "Key not found. Tap to enter"
              : _getContent(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        onTap: _isEncryptionKeyNotFound()
            ? () => _enterEncryptionKey(context)
            : null,
        subtitle: Text(_fromNow()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editJournal(context),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteJournal(context),
            ),
          ],
        ),
      );
}
