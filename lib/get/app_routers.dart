import 'package:flutter_base/get/controller/get_login_controller.dart';
import 'package:flutter_base/get/ui/get_login_page.dart';
import 'package:flutter_base/web/web.dart';
import 'package:flutter_base/web/web_controller.dart';
import 'package:get/get.dart';

class AppRouters {
  AppRouters._();

  static const login = "/login";
  static const home = "/home";
  static const webView = "/webView";

  static final routers = [
    GetPage(
      name: login,
      page: () => const GetLoginPage(),
      binding: BindingsBuilder.put(
        () => LoginController(repository: Get.find()),
      ),
    ),
    GetPage(
      name: webView,
      page: () {
        final url = Get.arguments[IWebView.pUrl];
        return IWebView(url: url);
      },
      binding: BindingsBuilder.put(() => WebController()),
    ),
  ];
}
