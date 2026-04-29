import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';

class LoginRepository {
  final ApiService apiService;

  LoginRepository({required this.apiService});

  Future<UserVo> login(String phone, String pwd) async {
    await Future.delayed(Duration(seconds: 3));
    return UserVo(phone: phone, pwd: pwd);
  }
}
