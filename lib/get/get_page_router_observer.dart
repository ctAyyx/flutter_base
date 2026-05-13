import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetPageRouterObserver extends GetObserver {


  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouterIn(route);
    if (previousRoute != null) {
      _handleRouterOut(previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleRouterOut(route);
    if (previousRoute != null) {
      _handleRouterIn(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _handleRouterIn(newRoute);
    }
    if (oldRoute != null) {
      _handleRouterOut(oldRoute);
    }
  }

  void _handleRouterIn(Route<dynamic> route) {
    if (route is! PageRoute) {
      return;
    }
    //TODO 处理进入埋点
  }

  void _handleRouterOut(Route<dynamic> route) {
    if (route is! PageRoute) {
      return;
    }
    //TODO 处理离开埋点
  }
}
