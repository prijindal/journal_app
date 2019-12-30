import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/protobufs/user.pb.dart';

class JournalAppDrawer extends StatefulWidget {
  _JournalAppDrawerState createState() => _JournalAppDrawerState();
}

class _JournalAppDrawerState extends State<JournalAppDrawer> {
  @override
  initState() {
    super.initState();
  }

  User get _user => HttpApi.getInstance().user;

  String get _currentRoute {
    return ModalRoute.of(context).settings.name;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _user == null
              ? Container()
              : UserAccountsDrawerHeader(
                  accountName: Text("${_user.firstName} ${_user.lastName}"),
                  accountEmail: Text(_user.email),
                ),
          ListTile(
            title: Text("New Journal"),
            leading: Icon(Icons.add),
            onTap: _currentRoute == "/new"
                ? null
                : () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/new", (route) => false);
                  },
          ),
          ListTile(
            title: Text("Journals"),
            leading: Icon(Icons.note),
            onTap: _currentRoute == "/journal"
                ? null
                : () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/journal", (route) => false);
                  },
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: _currentRoute == "/settings"
                ? null
                : () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/settings", (route) => false);
                  },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              HttpApi.getInstance().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
