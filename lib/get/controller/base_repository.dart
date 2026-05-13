import 'package:flutter/cupertino.dart';
import 'package:flutter_base/riverpod/mvi/http/base_resp.dart';

class ApiException implements Exception {
  final int? code;
  final String? msg;

  ApiException({this.code, this.msg});

  @override
  String toString() {
    return "$code:$msg";
  }
}

class BaseRepository {
  Future<T?> request<T>(Future<BaseResponse<T>> future) async {
    final resp = await future;
    debugPrint("===>$resp");
    if (resp.isSuccess()) {
      return resp.data;
    }
    throw ApiException(code: resp.code, msg: resp.msg);
  }
}
