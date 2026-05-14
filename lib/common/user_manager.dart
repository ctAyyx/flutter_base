import 'package:get/get.dart';

enum LoginStatus { login, logout }

class UserManager {
  static final UserManager _instance = UserManager._();

  static UserManager get instance => _instance;

  UserManager._();

  Rx<LoginStatus> loginStatus = Rx(LoginStatus.logout);

  String? token;
  String? phone;

  void login() {
    loginStatus.value = LoginStatus.login;
  }

  void logout() {
    loginStatus.value = LoginStatus.logout;
  }
}
