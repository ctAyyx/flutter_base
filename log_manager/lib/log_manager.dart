export 'net/log_dio_interceptor.dart';
export 'ui/log_screen.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'log_bean.dart';
import 'ui/float_button.dart';

class LogManager {
  LogManager._();

  static bool isDebug = false;
  static final int maxLogs = 500;

  // 重置为系统颜色
  static final String _ansiReset = '\x1b[0m';

  // 普通日志颜色 蓝色
  static final String _ansiBlue = '\x1b[34m';

  // 错误日志颜色 红色
  static final String _ansiRed = '\x1b[31m';

  // 警告日志颜色 黄色
  static final String _ansiYellow = '\x1b[33m';

  // Http响应日志颜色 绿色
  static final String _ansiGreen = '\x1b[32m';

  // Http请求日志颜色 青色
  static final String _ansiCyan = '\x1b[36m';

  static String? _fsApi;
  static final ValueNotifier<List<LogEntity>> logsNotifier = ValueNotifier([]);

  static void showFloatButton(OverlayState? overlayState) {
    //
    FloatButton.show(overlayState);
  }

  static void init({required bool isDebug, String? fsApi}) {
    LogManager.isDebug = isDebug;
    if (!isDebug) return;
    _fsApi = fsApi;
    // 直接重写DebugPrint 会写入系统日志 导致界面频繁更新
    FlutterError.onError = (details) {
      putLog(details.exception, level: LogType.error);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      putLog(error, level: LogType.error);
      return true;
    };
  }

  static Future<void> send2Fs(LogEntity entity) async {
    final url = _fsApi;
    if (url == null || url.isEmpty) {
      return;
    }
    final dio = Dio();
    try {
      final Map<String, dynamic> data = {
        "msg_type": "text",
        "content": {"text": entity.getRMessage()},
      };
      await dio.post(
        url,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );
    } catch (_) {}
  }

  static Future<void> send2FsMul(List<LogEntity> logs) async {
    for (var entity in logs) {
      send2Fs(entity);
    }
  }

  static void putLog(dynamic msg, {LogType level = LogType.info}) {
    if (!isDebug) return;
    final currentList = List<LogEntity>.from(logsNotifier.value);
    if (currentList.length >= maxLogs) {
      currentList.removeAt(0);
    }
    currentList.add(LogEntity("$msg", level));
    logsNotifier.value = currentList;
  }

  static void log(dynamic msg, {LogType level = LogType.info}) {
    if (!isDebug) return;
    switch (level) {
      case LogType.httpRequest:
        debugPrint("$_ansiCyan$msg$_ansiReset");
        break;
      case LogType.httpResponse:
        debugPrint("$_ansiGreen$msg$_ansiReset");
        break;
      case LogType.httpError:
      case LogType.error:
        debugPrint("$_ansiRed$msg$_ansiReset");
        break;
      case LogType.info:
        debugPrint("$_ansiBlue$msg$_ansiReset");

        break;
      case LogType.warning:
        debugPrint("$_ansiYellow$msg$_ansiReset");
        break;
    }
    putLog(msg, level: level);
  }

  static void logI(dynamic msg) {
    log(msg, level: LogType.info);
  }

  static void logW(dynamic msg) {
    log(msg, level: LogType.warning);
  }

  static void logE(dynamic msg) {
    log(msg, level: LogType.error);
  }
}
