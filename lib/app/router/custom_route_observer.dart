import 'package:currency_converter/core/utils/logger/logger_utils.dart';
import 'package:flutter/material.dart';

/// Custom route observer that logs all route changes.
final class CustomRouteObserver extends NavigatorObserver {
  CustomRouteObserver({
    this.logPush = true,
    this.logPop = true,
    this.logReplace = true,
    this.logRemove = true,
  });

  final bool logPush;
  final bool logPop;
  final bool logReplace;
  final bool logRemove;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (logPush) {
      LoggerUtils.instance.logInfo(
        '[GoRouter] New route pushed: ${route.settings.name}, Previous route: ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (logPop) {
      LoggerUtils.instance.logInfo(
        '[GoRouter] Route popped: ${route.settings.name}, Previous route: ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (logReplace) {
      LoggerUtils.instance.logInfo(
        '[GoRouter] Route replaced: ${newRoute?.settings.name}, Old route: ${oldRoute?.settings.name}',
      );
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (logRemove) {
      LoggerUtils.instance.logInfo(
        '[GoRouter] Route removed: ${route.settings.name}, Previous route: ${previousRoute?.settings.name}',
      );
    }
  }
}
