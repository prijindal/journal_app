import 'package:drift/web.dart';

import './core.dart';

SharedDatabase constructDb() {
  return SharedDatabase(WebDatabase('db'));
}
