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
        ? const Color(0xFFB94A4A)
        : isAlert
        ? const Color(0xFFC57B32)
        : const Color(0xFF2B8A70);

    return AnimatedScale(
      scale: isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Card(
        elevation: 0,
        color: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE0E9E4)),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => isPressed = value),
          borderRadius: BorderRadius.circular(14),
          mouseCursor: SystemMouseCursors.click,
          hoverColor: accent.withValues(alpha: 0.08),
          splashColor: accent.withValues(alpha: 0.16),
          highlightColor: accent.withValues(alpha: 0.12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(14),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 12, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.sensor.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF18332F),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 17,
                              color: const Color(0xFF78908A),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _Metric(
                              Icons.thermostat_rounded,
                              '${widget.sensor.temperature.toString().replaceAll('.', ',')}°C',
                            ),
                            const SizedBox(width: 25),
                            _Metric(
                              Icons.water_drop_outlined,
                              '${widget.sensor.humidity}%',
                            ),
                            const Spacer(),
                            Text(
                              widget.sensor.status,
                              style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
        Icon(icon, size: 17, color: const Color(0xFF2B8A70)),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF18332F),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
