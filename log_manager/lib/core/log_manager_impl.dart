import 'dart:ui';

import 'package:flutter/material.dart';

import '../log_bean.dart';
import '../ui/float_button.dart';
import 'log_manager_config.dart';
import 'log_manager_interface.dart';

class LogManagerImpl implements ILogManager {
  const LogManagerImpl();

  static final String _ansiReset = '\x1b[0m';
  static final ValueNotifier<List<LogEntity>> logsNotifier = ValueNotifier([]);

  static LogManagerConfig _config = LogManagerConfig.init();



  @override
  void init({LogManagerConfig? config}) {
    _config = config ?? LogManagerConfig.init();
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
        debugPrint("${_config.httpRequestColor}$msg$_ansiReset");
        break;
      case LogType.httpResponse:
        debugPrint("${_config.httpResponseColor}$msg$_ansiReset");
        break;
      case LogType.httpError:
      case LogType.error:
        debugPrint("${_config.logErrorColor}$msg$_ansiReset");
        break;
      case LogType.info:
        debugPrint("${_config.logInfoColor}$msg$_ansiReset");

        break;
      case LogType.warning:
        debugPrint("${_config.logWaringColor}$msg$_ansiReset");
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
    final currentList = List<LogEntity>.from(logsNotifier.value);
    if (currentList.length >= _config.maxLogs) {
      currentList.removeAt(0);
    }
    currentList.add(LogEntity("$msg", level));
    logsNotifier.value = currentList;
  }

  @override
  ValueNotifier<List<LogEntity>>? getNotifier() {
    return logsNotifier;
  }

  @override
  LogManagerConfig? getConfig() {
    return _config;
  }
}
