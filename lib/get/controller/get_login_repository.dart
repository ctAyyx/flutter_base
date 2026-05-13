import 'package:flutter_base/get/controller/base_repository.dart';
import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';

class GetLoginRepository extends BaseRepository {
  final ApiService apiService;

  GetLoginRepository(this.apiService);

  Future<UserVo?> login({required String phone, required String pwd}) async {
    await Future.delayed(Duration(seconds: 3));
    return request(apiService.login({"phone": phone, "pwd": pwd}));
  }
}
