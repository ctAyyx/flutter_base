import 'dart:convert';

import 'package:flutter_base/common/log_util.dart';
import 'package:flutter_base/web/web_dto.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebHandler {
  Future<void> handleJsEvent(
    JavaScriptMessage message,
    WebViewController controller,
  ) async {
    final params = jsonDecode(message.message);
    LogUtil.log("Web Request Params:$params");
  }

  void disposed() {}

  Future<void> sendResultToJs<T>(
    WebViewController controller,
    JsResponseVo<T> resp,
  ) async {
    final jsonData = jsonEncode(resp.toJson((value) => value));
    LogUtil.log("Web Response Params:$jsonData");
    // await controller.runJavaScript("callWeb($jsonData);");
  }
}
