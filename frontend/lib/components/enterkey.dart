import 'package:flutter/material.dart';

Future<String> enterKeyModal(BuildContext context) async {
  final TextEditingController _encyptionKeyController = TextEditingController();
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
  return encryptionKey;
}
