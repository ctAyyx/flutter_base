import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/get/http/log_interceptor.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';

import '../../riverpod/mvi/http/base_net.dart';

class ApiWorker {
  static ApiService buildApiService({required String baseUrl}) {
    final option = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    );
    final dio = Dio(option);
    final headerInterceptor = HeaderInterceptor();
    dio.interceptors.add(headerInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor());
    }
    final transformer = DecAndEndTransformer();
    dio.transformer = transformer;
    return ApiService(dio);
  }
}
