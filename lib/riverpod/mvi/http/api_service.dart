import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';
import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:flutter_base/riverpod/mvi/http/base_resp.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../constants.dart';
part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("/home/info")
  Future<BaseResponse<HomeVo>> queryHomeInfo();

  @POST("/login")
  Future<BaseResponse<UserVo>> login(@Body() Map<String, dynamic> body);

  @GET("/login2")
  Future<BaseResponse<UserVo>> login2(@Query("id") String id);


  @Headers({uriPath: "8V2630iS+j/IevtW15nLvQYFFQowWUwmfAyQ/iAaJJk="})
  @GET("api/info")
  Future<BaseResponse<dynamic>> requestHomeInfo();
}
