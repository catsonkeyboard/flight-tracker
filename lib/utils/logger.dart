

import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  static void log(Object? msg) {
    if (kDebugMode) print(msg);
  }
}
