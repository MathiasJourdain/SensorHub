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
        repository: const FakeSensorRepository(
          delay: Duration(milliseconds: 1),
        ),
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
      repository: const FakeSensorRepository(error: 'Erreur réseau'),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Failure<List<Sensor>>>());
    expect(
      (viewModel.state as Failure<List<dynamic>>).message,
      contains('Erreur réseau'),
    );

    viewModel.dispose();
  });
}
