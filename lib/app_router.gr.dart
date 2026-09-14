// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [SensorDetailPage]
class SensorDetailRoute extends PageRouteInfo<SensorDetailRouteArgs> {
  SensorDetailRoute({
    Key? key,
    required Sensor sensor,
    List<PageRouteInfo>? children,
  }) : super(
         SensorDetailRoute.name,
         args: SensorDetailRouteArgs(key: key, sensor: sensor),
         initialChildren: children,
       );

  static const String name = 'SensorDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SensorDetailRouteArgs>();
      return SensorDetailPage(key: args.key, sensor: args.sensor);
    },
  );
}

class SensorDetailRouteArgs {
  const SensorDetailRouteArgs({this.key, required this.sensor});

  final Key? key;

  final Sensor sensor;

  @override
  String toString() {
    return 'SensorDetailRouteArgs{key: $key, sensor: $sensor}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SensorDetailRouteArgs) return false;
    return key == other.key && sensor == other.sensor;
  }

  @override
  int get hashCode => key.hashCode ^ sensor.hashCode;
}

/// generated route for
/// [SensorListScreen]
class SensorListRoute extends PageRouteInfo<void> {
  const SensorListRoute({List<PageRouteInfo>? children})
    : super(SensorListRoute.name, initialChildren: children);

  static const String name = 'SensorListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SensorListScreen();
    },
  );
}
