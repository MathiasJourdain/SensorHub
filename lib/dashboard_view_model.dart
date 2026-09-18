import 'package:flutter/foundation.dart';

import 'sensor.dart';
import 'sensor_repository.dart';

sealed class AsyncState<T> {
  const AsyncState();
}

final class Loading<T> extends AsyncState<T> {
  const Loading();
}

final class Content<T> extends AsyncState<T> {
  final T value;
  const Content(this.value);
}

final class Failure<T> extends AsyncState<T> {
  final String message;
  const Failure(this.message);
}

class DashboardViewModel extends ChangeNotifier {
  final SensorRepository _repository;
  AsyncState<List<Sensor>> _state = const Loading();
  DashboardViewModel({SensorRepository? repository})
    : _repository =
          repository ??
          (simulateRepositoryError
              ? const FakeSensorRepository(error: 'Erreur réseau')
              : const FakeSensorRepository());
  AsyncState<List<Sensor>> get state => _state;
  List<Sensor> get sensors => switch (_state) {
    Content(value: final value) => value,
    _ => const <Sensor>[],
  };

  int get sensorCount => sensors.length;
  int get onlineCount =>
      sensors.where((sensor) => sensor.status != 'Hors ligne').length;
  bool get hasOfflineSensors =>
      sensors.any((sensor) => sensor.status == 'Hors ligne');
  Future<void> load() async {
    _setState(const Loading());
    try {
      final sensors = await _repository.fetchAll();
      _setState(Content(List.unmodifiable(sensors)));
    } catch (error) {
      _setState(Failure(error.toString()));
    }
  }

  void _setState(AsyncState<List<Sensor>> value) {
    _state = value;
    notifyListeners();
  }
}
