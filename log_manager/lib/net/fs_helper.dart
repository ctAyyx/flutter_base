import 'package:dio/dio.dart';
import '../core/log_manager.dart';

import '../log_bean.dart';

class FsHelper {
  FsHelper._();

  static Future<void> send2Fs(LogEntity entity) async {
    final url = LogManager.getConfig()?.fsApi;
    if (url == null || url.isEmpty) {
      return;
    }
    final dio = Dio();
    try {
      final Map<String, dynamic> data = {
        "msg_type": "text",
        "content": {"text": entity.getRMessage()},
      };
      await dio.post(
        url,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );
    } catch (_) {}
  }

  static Future<void> send2FsMul(List<LogEntity> logs) async {
    for (var entity in logs) {
      send2Fs(entity);
    }
  }
}
