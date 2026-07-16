import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base/common/misty_util.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../log/log_dio.dart';

final apiServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

final dioProvider = Provider((ref) {
  final option = BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    contentType: Headers.jsonContentType,
  );
  final dio = Dio(option);
  final headerInterceptor = HeaderInterceptor();
  dio.interceptors.add(headerInterceptor);
  dio.interceptors.add(LogDioInterceptor());
  final transformer = EncryptDecryptTransformer();
  dio.transformer = transformer;
  return dio;
});

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

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Map<String, dynamic> header = {
      Constants.version: 1,
      Constants.token: "6bf9ce36-9541-4d1d-8e7e-3d768844e582",
      Constants.deviceId: "577E8E2B-9BE9-47EE-88C3-9833DF67F26F",
      Constants.platform: "android",
      Constants.packageName: "com.vietnam.at",
      Constants.systemVersion: 14,
    };
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}

class EncryptDecryptTransformer extends Transformer {
  final Transformer _defaultTransformer = BackgroundTransformer();

  @override
  Future<String> transformRequest(RequestOptions options) async {
    if (!_shouldCrypto(options)) {
      return _defaultTransformer.transformRequest(options);
    }

    final data = options.data;
    if (data == null || !_isEncryptType(data)) {
      return _defaultTransformer.transformRequest(options);
    }

    final processedData = data is String ? data.trim() : jsonEncode(data);
    final encryptedBody = processedData.encrypt();
    options.data = encryptedBody;
    return _defaultTransformer.transformRequest(options);
  }

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    if (!_shouldCrypto(options)) {
      return _defaultTransformer.transformResponse(options, responseBody);
    }

    final responseData = await utf8.decodeStream(responseBody.stream);
    final decryptedData = responseData.decrypt();
    try {
      return jsonDecode(decryptedData);
    } catch (e) {
      return decryptedData;
    }
  }

  bool _shouldCrypto(RequestOptions options) =>
      !['GET'].contains(options.method);

  bool _isEncryptType(dynamic data) =>
      data is Map || data is List || data is String;
}
