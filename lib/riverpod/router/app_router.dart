import 'package:auto_route/auto_route.dart';
import 'package:flutter_base/riverpod/main.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen|Page,Route")
class AppRouter extends RootStackRouter {
  AppRouter() :super(navigatorKey: navigatorKey);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: CreditRoute.page),
        AutoRoute(
          page: MainRoute.page,
          path: "/main",
          initial: false,
          children: [
            AutoRoute(page: HomeRoute.page, path: "home"),
            AutoRoute(page: BillRoute.page, path: "bill"),
            AutoRoute(page: SettingRoute.page, path: "setting"),
          ],
        ),
      ];
}
