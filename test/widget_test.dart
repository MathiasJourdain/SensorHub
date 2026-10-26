// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tp_capteurs/dashboard_view_model.dart';
import 'package:tp_capteurs/sensor_repository.dart';
import 'package:tp_capteurs/sensor.dart';

void main() {
  test(
    'loads sensors through the repository and notifies each transition',
    () async {
      final viewModel = DashboardViewModel(
        FakeSensorRepository(delay: Duration(milliseconds: 1)),
      );
      final states = <AsyncState<List<Sensor>>>[];

      viewModel.addListener(() => states.add(viewModel.state));
      final loading = viewModel.load();

      expect(viewModel.state, isA<Loading<List<Sensor>>>());
      await loading;

      expect(viewModel.state, isA<Content<List<Sensor>>>());
      expect(viewModel.sensors, hasLength(3));
      expect(states, hasLength(2));

      viewModel.dispose();
    },
  );

  test('publishes a failure when the repository throws', () async {
    final viewModel = DashboardViewModel(
      FakeSensorRepository(error: 'Erreur réseau'),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Failure<List<Sensor>>>());
    expect(
      (viewModel.state as Failure<List<dynamic>>).message,
      contains('Erreur réseau'),
    );

    viewModel.dispose();
  });

  test(
    'retries successfully on the same view model after an initial failure',
    () async {
      final repository = FakeSensorRepository(
        error: 'Erreur réseau',
        failuresBeforeSuccess: 1,
      );
      final viewModel = DashboardViewModel(repository);

      await viewModel.load();
      expect(viewModel.state, isA<Failure<List<Sensor>>>());
      expect(viewModel.lastSuccessfulRefresh, isNull);

      await viewModel.load();
      expect(viewModel.state, isA<Content<List<Sensor>>>());
      expect(viewModel.sensors, hasLength(3));
      expect(repository.loadCount, 2);
      expect(viewModel.lastSuccessfulRefresh, isNotNull);

      viewModel.dispose();
    },
  );

  test('ignores repeated loads until the current request completes', () async {
    final repository = FakeSensorRepository(
      delay: const Duration(milliseconds: 20),
    );
    final viewModel = DashboardViewModel(repository);

    final firstLoad = viewModel.load();
    final repeatedLoads = Future.wait([
      viewModel.load(),
      viewModel.load(),
      viewModel.load(),
    ]);

    expect(viewModel.isLoading, isTrue);
    await Future.wait([firstLoad, repeatedLoads]);

    expect(repository.loadCount, 1);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.state, isA<Content<List<Sensor>>>());

    await viewModel.load();
    expect(repository.loadCount, 2);

    viewModel.dispose();
  });

  test('keeps the last successful refresh after a later failure', () async {
    var shouldFail = false;
    final repository = _SwitchableSensorRepository(
      shouldFail: () => shouldFail,
    );
    final viewModel = DashboardViewModel(repository);

    await viewModel.load();
    final lastSuccess = viewModel.lastSuccessfulRefresh;
    expect(lastSuccess, isNotNull);

    shouldFail = true;
    await viewModel.load();

    expect(viewModel.state, isA<Failure<List<Sensor>>>());
    expect(viewModel.lastSuccessfulRefresh, lastSuccess);

    viewModel.dispose();
  });

  test('marks successful data stale after the configured threshold', () async {
    final viewModel = DashboardViewModel(
      FakeSensorRepository(),
      staleAfter: const Duration(milliseconds: 20),
    );

    await viewModel.load();
    expect(viewModel.hasStaleData, isFalse);

    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(viewModel.hasStaleData, isTrue);

    await viewModel.load();
    expect(viewModel.hasStaleData, isFalse);

    viewModel.dispose();
  });
}

class _SwitchableSensorRepository implements SensorRepository {
  final bool Function() shouldFail;

  _SwitchableSensorRepository({required this.shouldFail});

  @override
  Future<List<Sensor>> fetchAll() async {
    if (shouldFail()) {
      throw Exception('Erreur réseau');
    }
    return FakeSensorRepository().data;
  }
}
