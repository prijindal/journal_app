import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../components/journal_list.dart';
import '../models/core.dart';
import '../models/drift.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.showHidden = false,
  });
  final bool showHidden;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  List<JournalEntryData>? _journalEntries;
  StreamSubscription<List<JournalEntryData>>? _subscription;

  @override
  void initState() {
    _addWatcher();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _addWatcher() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    var query = MyDatabase.instance.journalEntry.select();
    if (!widget.showHidden) {
      query.where((tbl) => tbl.hidden.equals(false));
    }
    if (_searchQueryController.text.isNotEmpty) {
      query = query
        ..where((tbl) =>
            tbl.tags.contains(_searchQueryController.text) |
            tbl.document.contains(_searchQueryController.text));
    }
    _subscription = (query
          ..orderBy(
            [
              (t) => drift.OrderingTerm(
                    expression: t.creationTime,
                    mode: drift.OrderingMode.desc,
                  ),
            ],
          ))
        .watch()
        .listen((event) {
      setState(() {
        _journalEntries = event;
      });
    });
  }

  void _updateSearchQuery(String query) {
    _addWatcher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchQueryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search Data...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white30),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: (query) => _updateSearchQuery(query),
        ),
      ),
      body: _searchQueryController.text.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Enter a search query...")],
            )
          : JournalList(
              entries: _journalEntries,
              showHidden: widget.showHidden,
            ),
    );
  }
}
