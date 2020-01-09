import 'package:flutter/material.dart';
import 'package:journal_app/helpers/encrypt.dart';

class EncryptionModalReturn {
  String encryptionKey;
  bool shouldSave;

  EncryptionModalReturn(this.encryptionKey, this.shouldSave);
}

/* Return true if success*/
Future<bool> enterKeyModalAndSave(BuildContext context) async {
  final encryptionKeyModal = await enterKeyModal(context);
  final encryptionKey = encryptionKeyModal.encryptionKey;
  final shouldSave = encryptionKeyModal.shouldSave;
  if (encryptionKey == null) {
    return false;
  } else {
    EncryptionService.getInstance().setEncryptionKey(encryptionKey, shouldSave);
    EncryptionService.getInstance().encryptJournals();
    return true;
  }
}

Future<EncryptionModalReturn> enterKeyModal(BuildContext context) async {
  final EncryptionModalReturn encryptionModalReturn =
      await showDialog<EncryptionModalReturn>(
    context: context,
    builder: (context) => EncryptionModal(),
  );
  return encryptionModalReturn;
}

class EncryptionModal extends StatefulWidget {
  _EncryptionModalState createState() => _EncryptionModalState();
}

class _EncryptionModalState extends State<EncryptionModal> {
  final TextEditingController _encyptionKeyController = TextEditingController();
  bool _shouldSave = false;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text("Enter encyption key"),
        children: <Widget>[
          ListTile(
            title: TextFormField(
              controller: _encyptionKeyController,
              maxLength: 32,
            ),
          ),
          SwitchListTile(
            title: Text("Save Encryption Key"),
            value: _shouldSave,
            onChanged: (newValue) {
              setState(() {
                _shouldSave = newValue;
              });
            },
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(
                  EncryptionModalReturn(null, false),
                ),
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () => Navigator.of(context).pop(
                  EncryptionModalReturn(
                      _encyptionKeyController.text, _shouldSave),
                ),
              ),
            ],
          )
        ],
      );
}
