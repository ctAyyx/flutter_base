import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/common/log_util.dart';
import 'package:flutter_base/get/app_routers.dart';
import 'package:flutter_base/riverpod/mvi/bean/user.dart';
import 'package:flutter_base/web/web_controller.dart';
import 'package:flutter_base/web/web_dto.dart';
import 'package:flutter_base/web/web_handler.dart';
import 'package:flutter_base/web/web_router.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class IWebView extends StatefulWidget {
  static const String pUrl = "web_url";
  static const String _webChannelName = "Native";

  static Future<T?>? startByRouter<T>({
    required WebRouter webRouter,
    Map<String, String>? params,
  }) {
    return start(url: "xxx${webRouter.path}", params: params);
  }

  static Future<T?>? start<T>({
    required String url,
    Map<String, String>? params,
  }) {
    String cleanedUrl = url.replaceAll(RegExp(r'(?<!:)/+'), '/');
    Uri baseUri = Uri.parse(cleanedUrl);
    final urlParams = Map<String, String>.from(baseUri.queryParameters);
    if (params != null && params.isNotEmpty) {
      urlParams.addAll(params);
    }
    urlParams["ts"] = "${DateTime.now().millisecondsSinceEpoch}";
    baseUri = baseUri.replace(queryParameters: urlParams);
    final finalUrl = baseUri.toString();
    return Get.toNamed(AppRouters.webView, arguments: {pUrl: finalUrl});
  }

  final String url;

  const IWebView({super.key, required this.url});

  @override
  State<IWebView> createState() => _IWebViewState();
}

class _IWebViewState extends State<IWebView> {
  late final WebViewController _webViewController;
  late WebHandler? _webHandler;
  final WebController _controller = Get.find<WebController>();

  @override
  void initState() {
    super.initState();
    _webHandler = WebHandler();
    _initWebViewController();
  }

  @override
  void dispose() {
    _webHandler?.disposed();
    _webHandler = null;
    super.dispose();
  }

  void _initWebViewController() {
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
            const PlatformWebViewControllerCreationParams(),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                _controller.initLoading();
              },
              onPageFinished: (String url) {
                _controller.endLoading();
              },
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          );
    _webViewController = controller;
    controller.addJavaScriptChannel(
      IWebView._webChannelName,
      onMessageReceived: (JavaScriptMessage message) {
        try {
          _webHandler?.handleJsEvent(message, _webViewController);
        } catch (e) {
          LogUtil.log("Web Error:$e");
        }
      },
    );
    _initAndroidConfig(controller);
    LogUtil.log(widget.url);
    controller.loadRequest(Uri.parse(widget.url));
  }

  void _initAndroidConfig(WebViewController controller) {
    if (!(Platform.isAndroid &&
        controller.platform is AndroidWebViewController)) {
      return;
    }
    final androidController = controller.platform as AndroidWebViewController;
    androidController
      ..setMixedContentMode(MixedContentMode.alwaysAllow)
      ..setAllowContentAccess(true)
      ..setOverScrollMode(WebViewOverScrollMode.never);
    androidController.setOnShowFileSelector((FileSelectorParams params) async {
      try {
        final result = await FilePicker.pickFiles(
          type: FileType.image,
          allowMultiple: params.mode == FileSelectorMode.openMultiple,
        );
        if (result != null && result.files.isNotEmpty) {
          return result.files
              .where((file) => file.path != null)
              .map((file) => Uri.file(file.path!).toString())
              .toList();
        }
      } catch (_) {
        //
      }
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (!didPop) {
            try {
              dynamic result = await _webViewController
                  .runJavaScriptReturningResult("onNativeBack()");
              if (result != false) {
                if (await _webViewController.canGoBack()) {
                  _webViewController.goBack();
                } else {
                  Get.back();
                }
              }
            } catch (_) {
              Get.back();
            }
          }
        },
        child: Scaffold(
          body: ObxLoadingContainer(
            isLoading: _controller.isLoadingObx,
            child: WebViewWidget(controller: _webViewController),
          ),
        ),
      ),
    );
  }
}
