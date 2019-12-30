import 'package:flutter/material.dart';
import 'package:journal_app/components/appbar.dart';
import 'package:journal_app/screens/editjournal.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:journal_app/api/api.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

class JournalsScreen extends StatefulWidget {
  _JournalsScreenState createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  JournalResponse _journalResponse;
  @override
  void initState() {
    super.initState();
    _getJournals();
  }

  Future<void> _getJournals() async {
    final journalResponse = await HttpApi.getInstance().getJournal();
    if (journalResponse == null) {
      Navigator.of(context).pushReplacementNamed("/login");
    } else {
      setState(() {
        this._journalResponse = journalResponse;
      });
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
                      onDelete: _getJournals,
                      onEdit: _getJournals,
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
    final date = new DateTime.fromMillisecondsSinceEpoch(
        journal.createdAt.toInt() * 1000);
    return timeago.format(date);
  }

  _deleteJournal() async {
    await HttpApi.getInstance().deleteJournal(journal.id);
    onDelete();
  }

  _editJournal(BuildContext context) async {
    EditJournalScreenArguments args = EditJournalScreenArguments(journal.id);
    await Navigator.of(context).pushNamed('/edit', arguments: args);
    onEdit();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(
          journal.content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
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
              onPressed: _deleteJournal,
            ),
          ],
        ),
      );
}
