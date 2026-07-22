import 'package:flutter/material.dart';

import '../bean/log_bean.dart';
import 'log_manager_config.dart';
import 'throttled_value_notifier.dart';

abstract class ILogManager {
  void init({LogManagerConfig? config});

  void showFloatButton({OverlayState? overlay});

  void putLog(dynamic msg, {LogType level = LogType.info});

  void log(dynamic msg, {LogType level = LogType.info});

  void logI(dynamic msg);

  void logW(dynamic msg);

  void logE(dynamic msg);

  ThrottledValueNotifier<LogEntity>? getNotifier();

  LogManagerConfig? getConfig();
}

class LogManagerNull implements ILogManager {
  const LogManagerNull();

  @override
  void log(msg, {LogType level = LogType.info}) {}

  @override
  void logE(msg) {}

  @override
  void logI(msg) {}

  @override
  void logW(msg) {}

  @override
  void showFloatButton({OverlayState? overlay}) {}

  @override
  void putLog(msg, {LogType level = LogType.info}) {}

  @override
  ThrottledValueNotifier<LogEntity>? getNotifier() {
    return null;
  }

  @override
  LogManagerConfig? getConfig() {
    return null;
  }

  @override
  void init({LogManagerConfig? config}) {}
}
