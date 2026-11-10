import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/dummy_iot_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  IotDashboardData _data = DummyIotService.initialData;

  void _toggleConnection() {
    setState(() {
      _data = _data.copyWith(isConnected: !_data.isConnected);
    });
  }

  void _showExpandedChart() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Temperature (°C)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                width: double.infinity,
                child: CustomPaint(
                  painter: _TemperatureChartPainter(_data.history),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _data.history
                    .map(
                      (p) => Text(
                        p.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildKpiGrid(),
              const SizedBox(height: 16),
              _buildMqttCard(),
              const SizedBox(height: 16),
              _buildHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final connected = _data.isConnected;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IoT Monitoring',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Dashboard Monitoring Sensor',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: 'Toggle MQTT connection status',
          child: InkWell(
            onTap: _toggleConnection,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: connected
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: connected
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    connected ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: connected
                          ? const Color(0xFF15803D)
                          : const Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiGrid() {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            icon: Icons.thermostat_outlined,
            label: 'Temperature',
            value: '${_data.temperature.toStringAsFixed(1)}°C',
            sublabel: _data.sensorName,
            backgroundColor: const Color(0xFFEFF6FF),
            accentColor: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${_data.humidity}%',
            sublabel: _data.sensorName,
            backgroundColor: const Color(0xFFF0FDF4),
            accentColor: const Color(0xFF16A34A),
          ),
        ),
      ],
    );
  }

  Widget _buildMqttCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MQTT Connection',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          _MqttRow(label: 'Broker', value: _data.broker),
          const SizedBox(height: 6),
          _MqttRow(label: 'Topic', value: _data.topic),
          const SizedBox(height: 6),
          _MqttRow(label: 'Last Update', value: _data.lastUpdate),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitoring History',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Temperature (°C)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Dummy Data',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Contoh data simulasi untuk desain dashboard.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showExpandedChart,
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 36),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Expand chart',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _TemperatureChartPainter(_data.history),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Temperature',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          ..._data.history.map(
            (point) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    point.time,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    '${_formatTemp(point.temperature)}°C',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTemp(double temp) {
    return temp % 1 == 0 ? temp.toInt().toString() : temp.toStringAsFixed(1);
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sublabel;
  final Color backgroundColor;
  final Color accentColor;

  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.backgroundColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _MqttRow extends StatelessWidget {
  final String label;
  final String value;

  const _MqttRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _TemperatureChartPainter extends CustomPainter {
  final List<TemperaturePoint> points;

  _TemperatureChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5;

    const padLeft = 8.0;
    const padRight = 12.0;
    const padTop = 12.0;
    const padBottom = 12.0;

    final chartWidth = size.width - padLeft - padRight;
    final chartHeight = size.height - padTop - padBottom;

    // L-shaped axes
    canvas.drawLine(
      const Offset(padLeft, padTop),
      Offset(padLeft, size.height - padBottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padLeft, size.height - padBottom),
      Offset(size.width - padRight, size.height - padBottom),
      axisPaint,
    );

    if (points.isEmpty) return;

    final minTemp = points.map((p) => p.temperature).reduce((a, b) => a < b ? a : b);
    final maxTemp = points.map((p) => p.temperature).reduce((a, b) => a > b ? a : b);
    final range = (maxTemp - minTemp) == 0 ? 1.0 : (maxTemp - minTemp);

    final offsets = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = padLeft + (points.length == 1 ? chartWidth / 2 : (i / (points.length - 1)) * chartWidth);
      final normalizedY = (points[i].temperature - minTemp) / range;
      final y = (size.height - padBottom) - (normalizedY * (chartHeight - 8)) - 4;
      offsets.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 1; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final dotFill = Paint()..color = const Color(0xFF2563EB);
    final dotStroke = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final offset in offsets) {
      canvas.drawCircle(offset, 5, dotFill);
      canvas.drawCircle(offset, 5, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _TemperatureChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
