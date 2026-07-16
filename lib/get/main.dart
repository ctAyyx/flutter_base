import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/get/app_binding.dart';
import 'package:flutter_base/get/app_routers.dart';
import 'package:flutter_base/get/get_page_router_observer.dart';
import 'package:flutter_base/riverpod/provider/app_provider.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final RouteObserver<PageRoute> appRouterObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (_) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleListener _lifecycleListener = AppLifecycleListener(
    onStateChange: _onStateChange,
  );

  void _onStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _lifecycleListener;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 测试模式
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: "GetX MVC",
      initialBinding: AppBinding(),
      navigatorObservers: [GetPageRouterObserver(), appRouterObserver],
      initialRoute: AppRouters.init,
      getPages: AppRouters.routers,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      defaultTransition: Transition.cupertino,
    );
    ;
  }
}
