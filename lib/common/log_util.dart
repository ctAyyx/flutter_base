import 'package:flutter/cupertino.dart';

class LogUtil {
  LogUtil._();

  static void log(dynamic body) {
    debugPrint("$body");
  }
}
