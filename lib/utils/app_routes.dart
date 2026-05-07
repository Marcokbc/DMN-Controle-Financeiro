import 'package:flutter/material.dart';

import '../views/auth/auth_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/analytics/analytics_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const AuthView(),
    '/dashboard': (_) => const DashboardView(),
    '/analytics': (_) => const AnalyticsView(),
  };
}