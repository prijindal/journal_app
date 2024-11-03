import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalDate extends StatelessWidget {
  const JournalDate({
    super.key,
    required this.creationTime,
  });

  final DateTime creationTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat("d MMM y | E").format(creationTime)),
        Text(
          DateFormat.jm().format(creationTime),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
