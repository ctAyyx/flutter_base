import 'package:flutter_base/get/controller/base_controller.dart';

class WebController extends BaseController {
  @override
  void initLoading() {
    isLoadingObx.value = true;
  }

  void endLoading() {
    isLoadingObx.value = false;
  }
}
