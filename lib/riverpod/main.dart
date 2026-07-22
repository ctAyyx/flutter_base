import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/riverpod/provider/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_sys/log_export.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //初始化配置
  // LogManager.init(
  //   config: LogManagerConfig.init(
  //     // 飞书webhook 用来发送日志到飞书
  //     fsApi: null,
  //     // 最大日志条数
  //     maxLogs: 500,
  //     // 日志刷新间隔
  //     throttleTime: 1000,
  //     // 普通日志颜色 蓝色
  //     logInfoColor: '\x1b[34m',
  //     // 错误日志颜色 红色
  //     logErrorColor: '\x1b[31m',
  //     // 警告日志颜色 黄色
  //     logWaringColor: '\x1b[33m',
  //     // Http响应日志颜色 绿色
  //     httpResponseColor: '\x1b[32m',
  //     // Http请求日志颜色 青色
  //     httpRequestColor: '\x1b[36m',
  //   ),
  // );
  debugPrint = (String? message, {int? wrapWidth}) {
    LogManager.log(message);
  };
  runApp(const ProviderScope(child: MyApp()));
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogManager.showFloatButton(overlay: navigatorKey.currentState?.overlay);
    });

  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router.config(
        navigatorObservers: () => [AppRouterObserver()],
      ),
    );
  }
}

class AppRouterObserver extends AutoRouterObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    LogManager.logI("Router:进入界面:${route.settings.name} -${route.runtimeType}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    LogManager.logW("Router:离开界面:${route.settings.name}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    LogManager.logW("Router:替换界面:${newRoute?.settings.name}");
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    super.didInitTabRoute(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
  }
}
