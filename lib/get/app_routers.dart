import 'dart:ui';

import 'package:flutter_base/get/controller/get_bill_controller.dart';
import 'package:flutter_base/get/controller/get_home_controller.dart';
import 'package:flutter_base/get/controller/get_login_controller.dart';
import 'package:flutter_base/get/controller/get_main_controller.dart';
import 'package:flutter_base/get/controller/get_mine_controller.dart';
import 'package:flutter_base/get/ui/get_login_page.dart';
import 'package:flutter_base/get/ui/get_main_page.dart';
import 'package:flutter_base/web/web.dart';
import 'package:flutter_base/web/web_controller.dart';
import 'package:get/get.dart';

class AppRouters {
  AppRouters._();

  static const login = "/login";
  static const home = "/home";
  static const webView = "/webView";

  static const init = login;
  static final routers = [
    GetPage(
      name: login,
      page: () => const GetLoginPage(),
      binding: BindingsBuilder.put(
        () => LoginController(repository: Get.find()),
      ),
    ),
    GetPage(
      name: home,
      page: () => const GetMainPage(),
      binding: BindingsBuilder(() {
        Get.put(GetMainController());
        Get.put(GetHomeController());
        Get.put(GetBillController());
        Get.put(GetMineController());
      }),
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

void toHome({
  int targetIndex = 0,
  bool clearTask = true,
  bool reCreate = false,
}) {
  try {
    if (!reCreate && Get.currentRoute == AppRouters.home) {
      if (Get.isRegistered<GetMainController>()) {
        Get.find<GetMainController>().onTabClick(targetIndex);
      }
      return;
    }
    if (clearTask) {
      Get.offAllNamed(AppRouters.home, arguments: {"initPage": targetIndex});
    } else {
      if (Get.isRegistered<GetMainController>()) {
        Get.find<GetMainController>().onTabClick(targetIndex);
        Get.until((router) => router.settings.name == AppRouters.home);
      } else {
        Get.offAllNamed(AppRouters.home, arguments: {"initPage": targetIndex});
      }
    }
  } catch (_) {
    Get.toNamed(AppRouters.home, arguments: {"initPage": targetIndex});
  }
}
