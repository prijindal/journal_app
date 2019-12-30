import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';

class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {
  JournalAppBar() : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  _logout(BuildContext context) async {
    await HttpApi.getInstance().logout();
    Navigator.of(context).pushReplacementNamed("/login");
  }

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text("Journals"),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _logout(context),
            icon: new RotationTransition(
              turns: new AlwaysStoppedAnimation(180 / 360),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      );
}
