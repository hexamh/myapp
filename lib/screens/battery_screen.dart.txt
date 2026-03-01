import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});

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
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 96.0,
          lineWidth: 12.0,
          percent: 0.84,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.battery_charging_full, size: 32, color: primaryColor),
              Text(
                "84%",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Discharging",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          progressColor: primaryColor,
          backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 16),
        Text(
          'Approx. 5h 20m remaining based on current usage.',
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
                Text('Good', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                Text('28.0 °C', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
          _buildDetailRow(context, primaryColor, Icons.bolt, 'Status', 'Discharging'),
          _buildDetailRow(context, primaryColor, Icons.power, 'Power Source', 'Battery'),
          _buildDetailRow(context, primaryColor, Icons.memory, 'Technology', 'Li-Poly'),
          _buildDetailRow(context, primaryColor, Icons.electric_bolt, 'Voltage', '3914 mV'),
          _buildDetailRow(context, primaryColor, Icons.battery_full, 'Capacity', '3000 mAh', isLast: true),
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
