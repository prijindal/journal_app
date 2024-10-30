import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fleather/fleather.dart';

class ParchmentDocumentConverter
    extends TypeConverter<ParchmentDocument, String> {
  const ParchmentDocumentConverter();

  @override
  ParchmentDocument fromSql(String fromDb) {
    return ParchmentDocument.fromJson(
      jsonDecode(fromDb) as List<dynamic>,
    );
  }

  @override
  String toSql(ParchmentDocument value) {
    return jsonEncode(value.toJson());
  }
}
