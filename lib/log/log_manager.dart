import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/log/float_button.dart';

enum LogLevel { info, warning, error }

class LogEntity {
  final String message;
  final LogLevel level;
  final DateTime time;

  LogEntity(this.message, this.level) : time = DateTime.now();

  String getFormatTime() {
    String year = time.year.toString();
    String month = time.month.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');

    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    // 毫秒是3位数，所以用 padLeft(3, '0')
    String millisecond = time.millisecond.toString().padLeft(3, '0');

    String formatted = "$year-$month-$day $hour:$minute:$second:$millisecond";

    return formatted;
  }

  String getRMessage() {
    RegExp regExp = RegExp(r"^(W:|I:|E:)");
    return message.replaceFirst(regExp, "");
  }
}

class LogManager {
  final String _ansiReset = '\x1b[0m';

  // 常用的前景色（文字颜色）
  final String _ansiWhite = '\x1b[37m';
  final String _ansiRed = '\x1b[31m'; // 红色：用于 Error
  final String _ansiYellow = '\x1b[33m'; // 黄色：用于 Warning
  final String _ansiGreen = '\x1b[32m'; // 绿色：用于 Response 成功
  final String _ansiCyan = '\x1b[36m'; // 青色：用于 Request 请求

  static final LogManager instance = LogManager._();
  bool isDebug = false;
  String? _fsApi =
      "https://open.feishu.cn/open-apis/bot/v2/hook/ebda5db2-b186-4c0a-8c1a-0751a3d8ab36";

  LogManager._();

  void showFloatButton(OverlayState? overlayState) {
    //
    FloatButton.show(overlayState);
  }

  void init({required bool isDebug, String? fsApi}) {
    this.isDebug = isDebug;
    if (!isDebug) return;
    // _fsApi = fsApi;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message == null || message.isEmpty) return;
      putLog(message);

      String printMsg = message;
      if (message.contains("[HTTP REQUEST]")) {
        printMsg = "$_ansiCyan$message$_ansiReset";
      } else if (message.contains("[HTTP RESPONSE]")) {
        printMsg = "$_ansiGreen$message$_ansiReset";
      } else if (message.contains("[HTTP ERROR]")) {
        printMsg = "$_ansiRed$message$_ansiReset";
      } else if (message.startsWith("I:")) {
        printMsg =
            "$_ansiWhite${message.replaceFirst(RegExp(r"I:"), "")}$_ansiReset";
      } else if (message.startsWith("W:")) {
        printMsg =
            "$_ansiYellow${message.replaceFirst(RegExp(r"W:"), "")}$_ansiReset";
      } else if (message.startsWith("E:")) {
        printMsg =
            "$_ansiRed${message.replaceFirst(RegExp(r"E:"), "")}$_ansiReset";
      }
      debugPrintThrottled(printMsg, wrapWidth: wrapWidth);
    };
    FlutterError.onError = (details) {
      putLog(details.exception, level: LogLevel.error);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      putLog(error, level: LogLevel.error);
      return true;
    };
  }

  Future<void> send2Fs(LogEntity entity) async {
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

  Future<void> send2FsMul(List<LogEntity> logs) async {
    for (var entity in logs) {
      send2Fs(entity);
    }
  }

  final ValueNotifier<List<LogEntity>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> filter = ValueNotifier(["", ""]);
  final int maxLogs = 500;

  void putLog(dynamic msg, {LogLevel level = LogLevel.info}) {
    if (!isDebug) return;
    final currentList = List<LogEntity>.from(logsNotifier.value);
    if (currentList.length >= maxLogs) {
      currentList.removeAt(0);
    }
    currentList.add(LogEntity("$msg", level));
    logsNotifier.value = currentList;
  }

  void logI(dynamic msg) {
    if (isDebug) {
      debugPrint("I:$msg");
    }
  }

  void logW(dynamic msg) {
    if (isDebug) {
      debugPrint("W:$msg");
    }
  }

  void logE(dynamic msg) {
    if (isDebug) {
      debugPrint("E:$msg");
    }
  }
}
