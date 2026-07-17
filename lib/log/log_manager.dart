import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/log/float_button.dart';
import 'package:flutter_base/log/util/time_util.dart';

enum LogLevel {
  info(key: "I:"),
  warning(key: "W:"),
  error(key: "E:"),
  httpRequest(key: "[HTTP请求]"),
  httpResponse(key: "[HTTP响应]"),
  httpError(key: "[HTTP错误]");

  final String key;

  const LogLevel({required this.key});
}

class LogEntity {
  final String message;
  final LogLevel level;
  final String time;

  LogEntity(this.message, this.level)
    : time = TimeUtil.getFormatTime(DateTime.now());

  String getRMessage() {
    RegExp regExp = RegExp(r"^(W:|I:|E:|N:)");
    return message.replaceFirst(regExp, "");
  }
}

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
      putLog(details.exception, level: LogLevel.error);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      putLog(error, level: LogLevel.error);
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
      final response = await dio.post(
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

  static void putLog(dynamic msg, {LogLevel level = LogLevel.info}) {
    if (!isDebug) return;
    final currentList = List<LogEntity>.from(logsNotifier.value);
    if (currentList.length >= maxLogs) {
      currentList.removeAt(0);
    }
    currentList.add(LogEntity("$msg", level));
    logsNotifier.value = currentList;
  }

  static void log(dynamic msg, {LogLevel level = LogLevel.info}) {
    if (!isDebug) return;
    switch (level) {
      case LogLevel.httpRequest:
        debugPrint("$_ansiCyan$msg$_ansiReset");
        break;
      case LogLevel.httpResponse:
        debugPrint("$_ansiGreen$msg$_ansiReset");
        break;
      case LogLevel.httpError:
      case LogLevel.error:
        debugPrint("$_ansiRed$msg$_ansiReset");
        break;
      case LogLevel.info:
        debugPrint("$_ansiBlue$msg$_ansiReset");

        break;
      case LogLevel.warning:
        debugPrint("$_ansiYellow$msg$_ansiReset");
        break;
    }
    putLog(msg, level:level);
  }

  static void logI(dynamic msg) {
    log(msg, level: LogLevel.info);
  }

  static void logW(dynamic msg) {
    log(msg, level: LogLevel.warning);
  }

  static void logE(dynamic msg) {
    log(msg, level: LogLevel.error);
  }
}
