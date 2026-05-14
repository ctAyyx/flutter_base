import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base/common/misty_util.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

final dioProvider = Provider((ref) {
  final option = BaseOptions(
    baseUrl: "",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    contentType: Headers.jsonContentType,
  );
  final dio = Dio(option);
  final headerInterceptor = HeaderInterceptor();
  dio.interceptors.add(headerInterceptor);
  final transformer = DecAndEndTransformer();
  dio.transformer = transformer;
  return dio;
});

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[""] = "";
    super.onRequest(options, handler);
  }
}

class DecAndEndTransformer extends BackgroundTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) {
    final data = options.data;
    if (data is String) {
      options.data = data.encrypt();
    }
    if (data is List || data is Map) {
      options.data = jsonEncode(data).encrypt();
    }
    return super.transformRequest(options);
  }

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    final stream = responseBody.stream;
    final parameter = await utf8.decodeStream(stream);
    return parameter.decrypt();
  }
}
