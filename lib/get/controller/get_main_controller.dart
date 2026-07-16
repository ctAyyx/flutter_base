import 'package:flutter/material.dart';
import 'package:flutter_base/get/controller/base_controller.dart';
import 'package:get/get.dart';

class GetMainController extends BaseController {
  final curPosition = 0.obs;
  late PageController? pageController;

  @override
  void onInit() {
    super.onInit();
    final initPosition = Get.arguments["initPage"] ?? 0;
    curPosition.value = initPosition;
    pageController = PageController(initialPage: initPosition);
  }

  void onTabClick(int index) {
    curPosition.value = index;
    pageController?.jumpToPage(index);
  }


}
