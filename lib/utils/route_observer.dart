import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);
    final prefs = await SharedPreferences.getInstance();
    if (route.settings.name != null) {
      prefs.setString("page", route.settings.name!);
    } else {
      prefs.setString("page", "-");
    }
    log('Route- pushed: to ${route.settings.name} from ${previousRoute?.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPop(route, previousRoute);
    final prefs = await SharedPreferences.getInstance();
    if (previousRoute != null && previousRoute.settings.name != null) {
      prefs.setString("page", previousRoute.settings.name!);
    } else {
      prefs.setString("page", "-");
    }
    log('Route- popped: pop ${route.settings.name} to ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) async {
    super.didRemove(route, previousRoute);
    final prefs = await SharedPreferences.getInstance();
    if (route.settings.name != null) {
      prefs.setString("page", route.settings.name!);
    } else {
      prefs.setString("page", "-");
    }
    log('Route- removed: new ${route.settings.name} removed ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) async {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final prefs = await SharedPreferences.getInstance();
    if (newRoute != null && newRoute.settings.name != null) {
      prefs.setString("page", newRoute.settings.name!);
    } else {
      prefs.setString("page", "-");
    }
    log('Route- replace: new ${newRoute?.settings.name} old ${oldRoute?.settings.name}');
  }
}
