import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'log_manager.dart';

class LogDioInterceptor extends Interceptor {
  static const String _keyTime = "log_dio_start_time";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (LogManager.instance.isDebug) {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      options.extra[_keyTime] = startTime;
      final buffer = StringBuffer();
      buffer.writeln('[HTTP REQUEST] ${options.method.toUpperCase()}');
      buffer.writeln('URL: ${options.uri}');
      buffer.writeln('─── Headers ───');
      options.headers.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
      if (options.data != null) {
        buffer.writeln('RequestBody: ${_prettyJson(options.data)}');
      }
      // 发送给我们的自研日志管理器
      debugPrint("请求==>${buffer.toString()}");
      LogManager.instance.putLog(buffer.toString(), level: LogLevel.info);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (LogManager.instance.isDebug) {
      final startTime = response.requestOptions.extra[_keyTime] as int?;
      String duration = "0ms";
      if (startTime != null) {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        duration = "${endTime - startTime}ms";
      }

      final buffer = StringBuffer();
      buffer.writeln(
        '[HTTP RESPONSE] | ${response.requestOptions.method.toUpperCase()} | Status Code:${response.statusCode} | $duration',
      );
      buffer.writeln('URL: ${response.requestOptions.uri}');
      if (response.data != null) {
        buffer.writeln('ResponseBody: ${_prettyJson(response.data)}');
      }
      debugPrint("响应==>${buffer.toString()}");
      LogManager.instance.putLog(buffer.toString(), level: LogLevel.info);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (LogManager.instance.isDebug) {
      final buffer = StringBuffer();
      buffer.writeln(
        '[HTTP ERROR] ${err.requestOptions.method.toUpperCase()} Status Code: ${err.response?.statusCode ?? 'UNKNOWN'}',
      );
      buffer.writeln('URL: ${err.requestOptions.uri}');
      buffer.writeln('Message: ${err.message}');
      if (err.response?.data != null) {
        buffer.writeln('Error Data: ${_prettyJson(err.response?.data)}');
      }
      // 错误网络日志，标记为 LogLevel.error 触发红色高亮
      debugPrint("错误==>${buffer.toString()}");
      LogManager.instance.putLog(buffer.toString(), level: LogLevel.error);
    }
    super.onError(err, handler);
  }

  // 辅助方法：美化 JSON 字符串，方便在手机屏幕上直观阅读
  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        final decoded = json.decode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
    } catch (_) {}
    return data.toString();
  }
}
