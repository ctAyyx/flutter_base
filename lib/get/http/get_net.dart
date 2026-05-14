import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
      dio.interceptors.add(ILogInterceptor());
    }
    final transformer = DecAndEndTransformer();
    //configProxy(dio);
    dio.transformer = transformer;
    return ApiService(dio);
  }

  static void configProxy(
    Dio dio, {
    String proxyUrl = "PROXY 192.168.30.69:8888",
  }) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient()
        ..findProxy = ((uri) => proxyUrl)
        ..badCertificateCallback = ((_, _, _) => true),
    );
  }
}
