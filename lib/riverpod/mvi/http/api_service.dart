import 'package:dio/dio.dart';
import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';
import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:flutter_base/riverpod/mvi/http/base_resp.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("/home/info")
  Future<BaseResponse<HomeVo>> queryHomeInfo();

  @POST("/login")
  Future<BaseResponse<UserVo>> login(@Body() Map<String, dynamic> body);
}
