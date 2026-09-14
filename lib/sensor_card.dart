import 'package:flutter/material.dart';

import 'sensor.dart';

class SensorCard extends StatefulWidget {
  final Sensor sensor;
  final VoidCallback onTap;

  const SensorCard({super.key, required this.sensor, required this.onTap});

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isOffline = widget.sensor.status == 'Hors ligne';
    final isAlert = widget.sensor.status == 'Alerte';
    final accent = isOffline
        ? const Color(0xFFC62828)
        : isAlert
        ? const Color(0xFFE07A5F)
        : const Color(0xFF087E8B);

    return AnimatedScale(
      scale: isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Card(
        elevation: isPressed ? 1 : 0,
        color: Colors.white.withValues(alpha: 0.86),
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => isPressed = value),
          borderRadius: BorderRadius.circular(18),
          mouseCursor: SystemMouseCursors.click,
          hoverColor: accent.withValues(alpha: 0.08),
          splashColor: accent.withValues(alpha: 0.16),
          highlightColor: accent.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.sensors_rounded, color: accent),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.sensor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF172A3A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded, color: Colors.blueGrey),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _Metric(
                      Icons.thermostat_rounded,
                      '${widget.sensor.temperature.toString().replaceAll('.', ',')}°C',
                    ),
                    const SizedBox(width: 24),
                    _Metric(
                      Icons.water_drop_outlined,
                      '${widget.sensor.humidity} %',
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAlert)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                size: 15,
                                color: accent,
                              ),
                            ),
                          Text(
                            widget.sensor.status,
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Metric(this.icon, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF087E8B)),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Color(0xFF172A3A)),
        ),
      ],
    );
  }
}
