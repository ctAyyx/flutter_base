import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/get/controller/base_repository.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  final _loadingCount = 0.obs;
  final isLoadingObx = false.obs;

  bool get isLoading => _loadingCount.value > 0;

  @override
  void onInit() {
    super.onInit();
    initLoading();
  }

  void initLoading() {
    ever(_loadingCount, (count) {
      isLoadingObx.value = count > 0;
    });
  }

  Future<T?> request<T>({
    required Future<T?> future,
    bool showLoading = true,
    Function(int? code, String? msg)? onError,
  }) async {
    try {
      if (showLoading) {
        _loadingCount.value++;
      }
      return await future;
    } catch (e) {
      int? code;
      String? errorMsg;
      switch (e) {
        case ApiException _:
          code = e.code;
          errorMsg = e.msg;
          break;
        case DioException _:
          code = -1;
          errorMsg = "Network Error";
          break;
        default:
          break;
      }
      if (onError != null) {
        onError(code, errorMsg);
      }
      return null;
    } finally {
      if (showLoading) {
        _loadingCount.value--;
      }
    }
  }
}
