import 'dart:async';

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
  final Duration staleAfter;
  AsyncState<List<Sensor>> _state = const Loading();
  bool _loadInProgress = false;
  DateTime? _lastSuccessfulRefresh;
  Timer? _staleTimer;

  DashboardViewModel(
    SensorRepository repository, {
    this.staleAfter = const Duration(seconds: 30),
  }) : _repository = repository;

  AsyncState<List<Sensor>> get state => _state;
  bool get isLoading => _loadInProgress;
  DateTime? get lastSuccessfulRefresh => _lastSuccessfulRefresh;
  bool get hasStaleData =>
      _lastSuccessfulRefresh != null &&
      DateTime.now().difference(_lastSuccessfulRefresh!) >= staleAfter;

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
    if (_loadInProgress) {
      return;
    }

    _loadInProgress = true;
    _setState(const Loading());
    try {
      final sensors = await _repository.fetchAll();
      _lastSuccessfulRefresh = DateTime.now();
      _staleTimer?.cancel();
      _staleTimer = Timer(staleAfter, () {
        if (!_loadInProgress && hasStaleData) {
          notifyListeners();
        }
      });
      _loadInProgress = false;
      _setState(Content(List.unmodifiable(sensors)));
    } catch (error) {
      _loadInProgress = false;
      _setState(Failure(error.toString()));
    }
  }

  void _setState(AsyncState<List<Sensor>> value) {
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _staleTimer?.cancel();
    super.dispose();
  }
}
