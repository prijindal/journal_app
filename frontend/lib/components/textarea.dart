import 'package:flutter/material.dart';

class JournalTextArea extends StatelessWidget {
  @required
  final TextEditingController controller;
  JournalTextArea({this.controller});
  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Write your journal",
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99999,
                autofocus: true,
              )
            ],
          ),
        ),
      );
}
