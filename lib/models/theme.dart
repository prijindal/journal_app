import 'package:flutter/material.dart';

final deleteDismissible = Container(
  color: Colors.red,
  alignment: AlignmentDirectional.centerStart,
  child: const Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  ),
);

final editDismissible = Container(
  color: Colors.blue,
  alignment: AlignmentDirectional.centerEnd,
  child: const Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
    child: Icon(
      Icons.edit,
      color: Colors.white,
    ),
  ),
);
