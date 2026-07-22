import 'package:dio/dio.dart';
import 'log_dio_interceptor_impl.dart';
import 'log_dio_interceptor_null.dart';
import '../core/log_manager.dart';

class LogDioInterceptor extends Interceptor {
  const LogDioInterceptor();

  static const Interceptor _proxy =
      LogManager.isRelease ? LogDioInterceptorNull() : LogDioInterceptorImpl();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _proxy.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    _proxy.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _proxy.onError(err, handler);
  }
}
