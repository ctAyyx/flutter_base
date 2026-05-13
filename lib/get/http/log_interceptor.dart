import 'package:dio/dio.dart';

class ILogInterceptor extends LogInterceptor {
  final filterLogs = [];

  ILogInterceptor({
    super.requestBody = true,
    super.responseBody = true,
    super.requestHeader = true,
    super.responseHeader = true,
  });

  bool _canLog(RequestOptions options) {
    return !filterLogs.any((path) => options.path.contains(path));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_canLog(options)) {
      super.onRequest(options, handler);
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_canLog(response.requestOptions)) {
      super.onResponse(response, handler);
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_canLog(err.requestOptions)) {
      super.onError(err, handler);
    } else {
      handler.next(err);
    }
  }
}
