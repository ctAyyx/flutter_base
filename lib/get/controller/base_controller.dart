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
    ever(_loadingCount, (count) {
      isLoadingObx.value = count > 0;
    });
  }

  Future<T?> request<T>({
    required Future<T?> future,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _loadingCount.value++;
      }
      return await future;
    } catch (e) {
      switch (e) {
        case ApiException e:
          break;
        case DioException e:
          break;
        default:
          break;
      }
      debugPrint("异常:$e");
      return null;
    } finally {
      if (showLoading) {
        _loadingCount.value--;
      }
    }
  }
}
