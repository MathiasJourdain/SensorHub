import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'app_router.dart';
import 'sensor.dart';
import 'sensor_card.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF4F1EA),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF087E8B),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF087E8B),
              onSurface: const Color(0xFF172A3A),
            ),
        fontFamily: 'monospace',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF172A3A),
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
  const SensorListScreen({super.key});

  @override
  State<SensorListScreen> createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen> {
  final List<Sensor> sensors = [
    const Sensor(
      id: '1',
      name: 'Salon',
      temperature: 21.8,
      humidity: 45,
      battery: 82,
      status: 'En ligne',
    ),
    const Sensor(
      id: '2',
      name: 'Garage',
      temperature: 29.6,
      humidity: 61,
      battery: 64,
      status: 'Alerte',
    ),
    const Sensor(
      id: '3',
      name: 'Jardin',
      temperature: 14.2,
      humidity: 80,
      battery: 12,
      status: 'Hors ligne',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SensorHub',
          style: TextStyle(
            color: Color(0xFF172A3A),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh_rounded),
            mouseCursor: SystemMouseCursors.click,
            hoverColor: const Color(0x1A087E8B),
            splashColor: const Color(0x40087E8B),
            highlightColor: const Color(0x30087E8B),
            splashRadius: 25,
            onPressed: () {
              // Logique de rafraîchissement future
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes capteurs',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF172A3A),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${sensors.length} appareils connectés à votre espace',
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Expanded(
              // 2. Afficher ces capteurs dans une liste
              child: ListView.builder(
                itemCount: sensors.length,
                itemBuilder: (context, index) {
                  // 3. Extraire et utiliser le widget SensorCard
                  final sensor = sensors[index];
                  return SensorCard(
                    sensor: sensor,
                    onTap: () =>
                        context.router.push(SensorDetailRoute(sensor: sensor)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
