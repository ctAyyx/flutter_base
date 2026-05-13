import 'package:flutter/material.dart';
import 'package:flutter_base/get/controller/base_controller.dart';
import 'package:flutter_base/get/controller/get_login_repository.dart';
import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final GetLoginRepository repository;

  late TextEditingController phoneController;
  late TextEditingController pwdController;

  final loginErrorInfo = "".obs;

  LoginController({required this.repository});

  Future<UserVo?> login() async {
    loginErrorInfo.value = "";
    final result = await request(showLoading: true,future: repository.login(phone: phoneController.text, pwd: pwdController.text));
    if (result == null) {
      loginErrorInfo.value = "登录失败";
    }
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    pwdController = TextEditingController();
  }

  @override
  void onClose() {
    phoneController.dispose();
    pwdController.dispose();
    super.onClose();
  }
}
