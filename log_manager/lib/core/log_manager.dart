import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:log_sys/core/throttled_value_notifier.dart';

import '../log_bean.dart';
import 'log_manager_config.dart';
import 'log_manager_impl.dart';
import 'log_manager_interface.dart';

class LogManager {
  LogManager._();

  static const String _env =
      String.fromEnvironment("APP_ENV", defaultValue: "release");
  static const bool isRelease = kReleaseMode && _env == "release";
  static const ILogManager _instance =
      isRelease ? LogManagerNull() : LogManagerImpl();

  static void init({LogManagerConfig? config}) {
    _instance.init(config: config);
  }

  static void log(dynamic msg, {LogType level = LogType.info}) {
    _instance.log(msg, level: level);
  }

  static void logE(dynamic msg) {
    _instance.logE(msg);
  }

  static void logI(dynamic msg) {
    _instance.logI(msg);
  }

  static void logW(dynamic msg) {
    _instance.logW(msg);
  }

  static void showFloatButton({OverlayState? overlay}) {
    _instance.showFloatButton(overlay: overlay);
  }

  static ThrottledValueNotifier<LogEntity>? getNotifier() {
    return _instance.getNotifier();
  }

  static LogManagerConfig? getConfig() {
    return _instance.getConfig();
  }
}
