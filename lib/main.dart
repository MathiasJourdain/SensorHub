import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'app_router.dart';
import 'dashboard_view_model.dart';
import 'sensor_card.dart';
import 'sensor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SensorHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF1D6B5B),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF1D6B5B),
              onSurface: const Color(0xFF18332F),
            ),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF18332F),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: appRouter.config(),
    );
  }
}

@RoutePage()
class SensorListScreen extends StatefulWidget {
  final DashboardViewModel? viewModel;

  const SensorListScreen({super.key, this.viewModel});

  @override
  State<SensorListScreen> createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen> {
  late final DashboardViewModel viewModel;
  late final bool ownsViewModel;

  @override
  void initState() {
    super.initState();
    ownsViewModel = widget.viewModel == null;
    viewModel = widget.viewModel ?? DashboardViewModel();
    viewModel.load();
  }

  @override
  void dispose() {
    if (ownsViewModel) {
      viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vos Capteurs',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color(0xFF18332F),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'État en temps réel',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6D817C),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${viewModel.sensorCount.toString().padLeft(2, '0')} ZONES',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6D817C),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Actualiser',
                            onPressed: viewModel.load,
                            icon: const Icon(Icons.refresh_rounded, size: 19),
                            color: Color(0xFF18332F),
                            style: IconButton.styleFrom(
                              backgroundColor: Color(0xFFE4EEE9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _OverviewStrip(sensors: viewModel.sensors),
                  const SizedBox(height: 18),
                  Expanded(child: _buildState(context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildState(BuildContext context) => switch (viewModel.state) {
    Loading() => const Center(child: CircularProgressIndicator()),
    Failure(message: final message) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 42),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: viewModel.load,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    ),
    Content(value: final sensors) when sensors.isEmpty => const Center(
      child: Text('Aucun capteur disponible'),
    ),
    Content(value: final sensors) => ListView.builder(
      itemCount: sensors.length,
      itemBuilder: (context, index) {
        final sensor = sensors[index];
        return SensorCard(
          sensor: sensor,
          onTap: () => context.router.push(SensorDetailRoute(sensor: sensor)),
        );
      },
    ),
  };
}

class _OverviewStrip extends StatelessWidget {
  final List<Sensor> sensors;

  const _OverviewStrip({required this.sensors});

  @override
  Widget build(BuildContext context) {
    final online = sensors
        .where((sensor) => sensor.status == 'En ligne')
        .length;
    final alerts = sensors.where((sensor) => sensor.status == 'Alerte').length;
    final offline = sensors
        .where((sensor) => sensor.status == 'Hors ligne')
        .length;

    return Row(
      children: [
        _OverviewItem(
          value: online,
          label: 'En ligne',
          color: const Color(0xFF2B8A70),
        ),
        const SizedBox(width: 8),
        _OverviewItem(
          value: alerts,
          label: 'Alerte',
          color: const Color(0xFFC57B32),
        ),
        const SizedBox(width: 8),
        _OverviewItem(
          value: offline,
          label: 'Hors ligne',
          color: const Color(0xFFB94A4A),
        ),
      ],
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _OverviewItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 10, 8, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFE0E9E4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6D817C)),
            ),
          ],
        ),
      ),
    );
  }
}
