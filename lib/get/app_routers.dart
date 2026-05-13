import 'package:flutter_base/get/controller/get_login_controller.dart';
import 'package:flutter_base/get/ui/get_login_page.dart';
import 'package:get/get.dart';

class AppRouters {
  AppRouters._();

  static const login = "/login";
  static const home = "/home";

  static final routers = [
    GetPage(
      name: login,
      page: () => const GetLoginPage(),
      binding: BindingsBuilder.put(
        () => LoginController(repository: Get.find()),
      ),
    ),
  ];
}
