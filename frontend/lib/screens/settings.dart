import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/components/appbar.dart';
import 'package:journal_app/components/appdrawer.dart';
import 'package:journal_app/helpers/encrypt.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pb.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Journal_JournalSaveType _saveType;
  @override
  void initState() {
    super.initState();
    _getType();
  }

  _getType() {
    setState(() {
      _saveType = getSaveType();
    });
  }

  _onChanged(Journal_JournalSaveType newType) async {
    String content = "";
    if (newType == Journal_JournalSaveType.LOCAL) {
      content =
          "Data wil NOT be stored in the cloud, and will be deleted as soon as you delete if phone is lost or app is deleted";
    } else if (newType == Journal_JournalSaveType.PLAINTEXT) {
      content =
          "This is the default and data will be stored in the cloud in plaintext";
    } else if (newType == Journal_JournalSaveType.ENCRYPTED) {
      content =
          "Data will be stored in encrypted format, if you forget the key, you lose your data";
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          RaisedButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirm) {
      if (newType == Journal_JournalSaveType.ENCRYPTED) {
        final TextEditingController _encyptionKeyController =
            TextEditingController();
        final String encryptionKey = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text("Enter encyption key"),
            children: <Widget>[
              TextFormField(
                controller: _encyptionKeyController,
                maxLength: 32,
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                  RaisedButton(
                    child: Text("Save"),
                    onPressed: () =>
                        Navigator.of(context).pop(_encyptionKeyController.text),
                  ),
                ],
              )
            ],
          ),
        );
        if (encryptionKey == null) {
          return;
        } else {
          FlutterPersistor.getInstance()
              .setString(ENCRYPTION_KEY, encryptionKey);
          encryptJournals();
        }
      } else if (newType == Journal_JournalSaveType.PLAINTEXT &&
          _saveType == Journal_JournalSaveType.ENCRYPTED) {
        decryptJournals();
      }
      setState(() {
        _saveType = newType;
      });
      FlutterPersistor.getInstance()
          .setString(SAVE_TYPE, newType.value.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: JournalAppBar(
          title: "Settings",
        ),
        drawer: JournalAppDrawer(),
        body: ListView(
          children: <Widget>[
            DropdownButton<Journal_JournalSaveType>(
              value: _saveType,
              onChanged: _onChanged,
              items: Journal_JournalSaveType.values
                  .map<DropdownMenuItem<Journal_JournalSaveType>>(
                    (value) => DropdownMenuItem<Journal_JournalSaveType>(
                      value: value,
                      child: Text(value.toString()),
                    ),
                  )
                  .toList(),
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
