import 'sensor.dart';

const Duration simulatedRepositoryDelay = Duration(seconds: 3);

abstract interface class SensorRepository {
  Future<List<Sensor>> fetchAll();
}

class FakeSensorRepository implements SensorRepository {
  final List<Sensor> data;
  final Duration delay;
  final Object? error;
  final int failuresBeforeSuccess;
  int _loadCount = 0;

  int get loadCount => _loadCount;

  FakeSensorRepository({
    this.data = const [
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
    ],
    this.delay = Duration.zero,
    this.error,
    this.failuresBeforeSuccess = 0,
  }) : assert(failuresBeforeSuccess >= 0);

  @override
  Future<List<Sensor>> fetchAll() async {
    _loadCount++;
    await Future<void>.delayed(delay);
    if (error != null &&
        (failuresBeforeSuccess == 0 || _loadCount <= failuresBeforeSuccess)) {
      throw error!;
    }
    return List.unmodifiable(data);
  }
}
