import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository({required this.apiService});

  Future<HomeVo> loadHomeInfo( int applyState) async {
    await Future.delayed(Duration(seconds: 3));
    return HomeVo(applyState: applyState);
  }
}
