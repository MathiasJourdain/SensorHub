import 'sensor.dart';

class DashboardViewModel {
  const DashboardViewModel();

  static const List<Sensor> _sensors = [
    Sensor(
      id: '1',
      name: 'Salon',
      temperature: 21.8,
      humidity: 45,
      battery: 82,
      status: 'En ligne',
    ),
    Sensor(
      id: '2',
      name: 'Garage',
      temperature: 29.6,
      humidity: 61,
      battery: 64,
      status: 'Alerte',
    ),
    Sensor(
      id: '3',
      name: 'Jardin',
      temperature: 14.2,
      humidity: 80,
      battery: 12,
      status: 'Hors ligne',
    ),
  ];

  List<Sensor> get sensors => _sensors;

  int get sensorCount => _sensors.length;

  int get onlineCount =>
      _sensors.where((sensor) => sensor.status != 'Hors ligne').length;

  bool get hasOfflineSensors =>
      _sensors.any((sensor) => sensor.status == 'Hors ligne');
}
