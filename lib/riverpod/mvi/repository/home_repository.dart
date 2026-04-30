import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';
import 'package:flutter_base/riverpod/mvi/http/api_service.dart';
import 'package:native_bridge/native_bridge.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository({required this.apiService});

  Future<HomeVo> loadHomeInfo(int applyState) async {
    await Future.delayed(Duration(seconds: 3));
    final appVersion = await NativeBridge.getPlatformVersion();
    return HomeVo(applyState: applyState, appVersion: appVersion);
  }
}
