import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _fetchBatteryInfo();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
      }
    });
  }

  Future<void> _fetchBatteryInfo() async {
    int batteryLevel = await _battery.batteryLevel;
    BatteryState state = await _battery.batteryState;
    if (mounted) {
      setState(() {
        _batteryLevel = batteryLevel;
        _batteryState = state;
      });
    }
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bolt, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeroBattery(context, primaryColor),
            const SizedBox(height: 32),
            _buildStatsCards(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildDetailedList(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildTipCard(context, primaryColor),
            const SizedBox(height: 80), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBattery(BuildContext context, Color primaryColor) {
    double percent = (_batteryLevel / 100).clamp(0.0, 1.0);
    Color progressColor = _batteryLevel < 20 ? Colors.red : primaryColor;

    IconData statusIcon = Icons.battery_full;
    if (_batteryState == BatteryState.charging) {
      statusIcon = Icons.battery_charging_full;
    } else if (_batteryLevel < 20) {
      statusIcon = Icons.battery_alert;
    }

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 96.0,
          lineWidth: 12.0,
          percent: percent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, size: 32, color: progressColor),
              Text(
                "$_batteryLevel%",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _batteryState.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          progressColor: progressColor,
          backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 16),
        Text(
          'Approx. time remaining N/A',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, Color? cardColor, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text('HEALTH', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('N/A', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.thermostat, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text('TEMP', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('N/A', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedList(BuildContext context, Color? cardColor, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildDetailRow(context, primaryColor, Icons.bolt, 'Status', _batteryState.name),
          _buildDetailRow(context, primaryColor, Icons.power, 'Power Source', 'Battery'),
          _buildDetailRow(context, primaryColor, Icons.memory, 'Technology', 'N/A'),
          _buildDetailRow(context, primaryColor, Icons.electric_bolt, 'Voltage', 'N/A'),
          _buildDetailRow(context, primaryColor, Icons.battery_full, 'Capacity', 'N/A', isLast: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, Color primaryColor, IconData icon, String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Battery Tip', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Keeping your battery between 20% and 80% can significantly extend its lifespan.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
