import 'package:flutter/material.dart';

import '../log_bean.dart';
import 'log_manager_config.dart';

abstract class ILogManager {
  void init({LogManagerConfig? config});


  void showFloatButton({OverlayState? overlay});

  void putLog(dynamic msg, {LogType level = LogType.info});

  void log(dynamic msg, {LogType level = LogType.info});

  void logI(dynamic msg);

  void logW(dynamic msg);

  void logE(dynamic msg);

  ValueNotifier<List<LogEntity>>? getNotifier();

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
  ValueNotifier<List<LogEntity>>? getNotifier() {
    return null;
  }

  @override
  LogManagerConfig? getConfig() {
    return null;
  }

  @override
  void init({LogManagerConfig? config}) {

  }
}
