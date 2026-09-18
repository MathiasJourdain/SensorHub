import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'sensor.dart';

@RoutePage()
class SensorDetailPage extends StatelessWidget {
  final Sensor sensor;

  const SensorDetailPage({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    final isOffline = sensor.status == 'Hors ligne';
    final isAlert = sensor.status == 'Alerte';
    final statusColor = isOffline
        ? const Color(0xFFB94A4A)
        : isAlert
        ? const Color(0xFFC57B32)
        : const Color(0xFF2B8A70);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Retour',
          icon: const Icon(Icons.arrow_back),
          mouseCursor: SystemMouseCursors.click,
          hoverColor: const Color(0x1A2B8A70),
          splashColor: const Color(0x402B8A70),
          highlightColor: const Color(0x302B8A70),
          splashRadius: 25,
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'FICHE CAPTEUR',
          style: TextStyle(
            color: Color(0xFF20313D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFE0E9E4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sensor.name,
                style: const TextStyle(
                  fontSize: 28,
                  color: Color(0xFF18332F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'DONNÉES DU JOUR',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    isOffline
                        ? Icons.cloud_off_rounded
                        : isAlert
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_rounded,
                    size: 19,
                    color: statusColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sensor.status,
                    style: TextStyle(
                      fontSize: 16,
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _DetailRow(
                'Température',
                '${sensor.temperature.toString().replaceAll('.', ',')}°C',
              ),
              _DetailRow('Humidité', '${sensor.humidity} %'),
              _DetailRow('Batterie', '${sensor.battery} %'),
              const SizedBox(height: 28),
              _DetailRow(
                'État',
                isOffline ? 'Hors ligne' : 'OK',
                valueColor: isOffline ? const Color(0xFFB94A4A) : null,
              ),
              const Spacer(),
              Text(
                'Dernière mesure',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF18332F),
              fontWeight: FontWeight.w700,
            ).copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
