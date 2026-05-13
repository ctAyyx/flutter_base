import 'package:flutter_base/get/controller/get_login_repository.dart';
import 'package:flutter_base/get/http/get_net.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiWorker.buildApiService(baseUrl: "https://www.baidu.com/"), permanent: true);
    Get.lazyPut<GetLoginRepository>(
      () => GetLoginRepository(Get.find<ApiService>()),
      fenix: true,
    );
  }
}
