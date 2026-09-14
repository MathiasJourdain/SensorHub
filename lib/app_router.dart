import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import 'main.dart';
import 'sensor_detail_page.dart';
import 'sensor.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SensorListRoute.page, initial: true),
    AutoRoute(page: SensorDetailRoute.page),
  ];
}

final appRouter = AppRouter();
