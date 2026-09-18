import 'sensor.dart';

const bool simulateRepositoryError = bool.fromEnvironment(
  'SIMULATE_ERROR',
  defaultValue: false,
);

abstract interface class SensorRepository {
  Future<List<Sensor>> fetchAll();
}

class FakeSensorRepository implements SensorRepository {
  final List<Sensor> data;
  final Duration delay;
  final Object? error;

  const FakeSensorRepository({
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
  });

  @override
  Future<List<Sensor>> fetchAll() async {
    await Future<void>.delayed(delay);
    if (error != null) {
      throw error!;
    }
    return List.unmodifiable(data);
  }
}
