import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:log_sys/core/throttled_value_notifier.dart';

import '../log_bean.dart';
import '../ui/float_button.dart';
import 'log_manager_config.dart';
import 'log_manager_interface.dart';

class LogManagerImpl implements ILogManager {
  const LogManagerImpl();

  static final String _ansiReset = '\x1b[0m';
  static LogManagerConfig _config = LogManagerConfig.init();
  static final ThrottledValueNotifier<LogEntity> logsNotifier =
      ThrottledValueNotifier();

  @override
  void init({LogManagerConfig? config}) {
    _config = config ?? LogManagerConfig.init();
    logsNotifier.setThrottleConfig(
        maxSize: _config.maxLogs, throttleTime: _config.throttleTime);
    FlutterError.onError = (details) {
      logE(details.exception);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      logE(error);
      return true;
    };
  }

  @override
  void log(msg, {LogType level = LogType.info}) {
    switch (level) {
      case LogType.httpRequest:
        debugPrintSynchronously("${_config.httpRequestColor}$msg$_ansiReset");
        break;
      case LogType.httpResponse:
        debugPrintSynchronously("${_config.httpResponseColor}$msg$_ansiReset");
        break;
      case LogType.httpError:
      case LogType.error:
        debugPrintSynchronously("${_config.logErrorColor}$msg$_ansiReset");
        break;
      case LogType.info:
        debugPrintSynchronously("${_config.logInfoColor}$msg$_ansiReset");

        break;
      case LogType.warning:
        debugPrintSynchronously("${_config.logWaringColor}$msg$_ansiReset");
        break;
    }
    putLog(msg, level: level);
  }

  @override
  void logE(msg) {
    log(msg, level: LogType.error);
  }

  @override
  void logI(msg) {
    log(msg, level: LogType.info);
  }

  @override
  void logW(msg) {
    log(msg, level: LogType.warning);
  }

  @override
  void showFloatButton({OverlayState? overlay}) {
    FloatButton.show(overlay);
  }

  @override
  void putLog(msg, {LogType level = LogType.info}) {
    // final currentList = List<LogEntity>.from(logsNotifier.value);
    // if (currentList.length >= _config.maxLogs) {
    //   currentList.removeAt(0);
    // }
    // currentList.add(LogEntity("$msg", level));
    // logsNotifier.value = currentList;
    logsNotifier.setValue(LogEntity("$msg", level));
  }

  @override
  ThrottledValueNotifier<LogEntity>? getNotifier() {
    return logsNotifier;
  }

  @override
  LogManagerConfig? getConfig() {
    return _config;
  }
}
