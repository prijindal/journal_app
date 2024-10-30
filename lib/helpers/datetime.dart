import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat("d MMM y | E | ").format(dateTime) +
      DateFormat.jm().format(dateTime);
}
