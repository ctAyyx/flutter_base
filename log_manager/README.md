<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

## Features

A tool for viewing logs in the app

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  log_sys:^1.0.1
```

## Usage

```
  // main.dart 
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  ...
    LogManager.init(
    // 如果需要配置
    config: LogManagerConfig.init(
      // 飞书webhook 用来发送日志到飞书
      fsApi: null,
      // 最大日志条数
      maxLogs: 500,
      // 日志刷新间隔
      throttleTime: 1000,
      // 普通日志颜色 蓝色
      logInfoColor: '\x1b[34m',
      // 错误日志颜色 红色
      logErrorColor: '\x1b[31m',
      // 警告日志颜色 黄色
      logWaringColor: '\x1b[33m',
      // Http响应日志颜色 绿色
      httpResponseColor: '\x1b[32m',
      // Http请求日志颜色 青色
      httpRequestColor: '\x1b[36m',
    ),
  );
   // 直接使用 打印日志
    LogManager.logI("蓝色日志");
    LogManager.logW("黄色日志");
    LogManager.logE("红色日志");
    // 或者在你自定义的日志工具里将日志存入
    LogManager.putLog("");
  //
  runApp(MyApp());
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // 开启全局悬浮按钮
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogManager.showFloatButton(navigatorKey.currentState?.overlay);
    });
  }

}
  
  //Option  Dio Interceptor
  dio.interceptors.add(LogDioInterceptor());
```

灰度环境打包命令
'flutter build apk --release --dart-define="APP_ENV=gray"'
或者使用
放置在项目根目录build.sh脚本执行
bash ./build.sh gray

release环境正常打包即可

## Additional information

