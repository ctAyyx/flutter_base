import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/log_manager.dart';

import '../log_bean.dart';

class LogDioInterceptorImpl extends Interceptor {
  const LogDioInterceptorImpl();
  final String _keyTime = "log_dio_start_time";


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    options.extra[_keyTime] = startTime;
    final buffer = StringBuffer();
    buffer.writeln(
        '${LogType.httpRequest.key} | ${options.method.toUpperCase()}');
    buffer.writeln('URL: ${options.uri}');
    buffer.writeln('─── Headers ───');
    options.headers.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    if (options.data != null) {
      buffer.writeln('Body: ${_prettyJson(options.data)}');
    }
    // 发送给我们的自研日志管理器
    LogManager.log(buffer.toString(), level: LogType.httpRequest);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra[_keyTime] as int?;
    String duration = "0ms";
    if (startTime != null) {
      final endTime = DateTime.now().millisecondsSinceEpoch;
      duration = "${endTime - startTime}ms";
    }

    final buffer = StringBuffer();
    buffer.writeln(
      '${LogType.httpResponse.key} | ${response.requestOptions.method.toUpperCase()} | Status:${response.statusCode} | $duration',
    );
    buffer.writeln('URL: ${response.requestOptions.uri}');
    if (response.data != null) {
      buffer.writeln('Body: ${_prettyJson(response.data)}');
    }
    LogManager.log(buffer.toString(), level: LogType.httpResponse);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln(
      '${LogType.httpError.key} | ${err.requestOptions.method.toUpperCase()} | Status: ${err.response?.statusCode ?? 'UNKNOWN'}',
    );
    buffer.writeln('URL: ${err.requestOptions.uri}');
    buffer.writeln('Message: ${err.message}');
    if (err.response?.data != null) {
      buffer.writeln('Error Data: ${_prettyJson(err.response?.data)}');
    }
    // 错误网络日志，标记为 LogLevel.error 触发红色高亮
    LogManager.log(buffer.toString(), level: LogType.httpError);
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
