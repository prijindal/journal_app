import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';

class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {
  @required
  final String title;
  JournalAppBar({this.title = "Journals"})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  _refresh() async {
    HttpApi.getInstance().getUser();
    HttpApi.getInstance().getJournal();
  }

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(this.title),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Scaffold.of(context).hasDrawer
                ? IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  )
                : null,
        actions: <Widget>[
          IconButton(
            onPressed: _refresh,
            icon: Icon(Icons.refresh),
          )
        ],
      );
}
