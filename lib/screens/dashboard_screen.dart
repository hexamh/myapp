import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:system_info2/system_info2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _deviceName = 'Loading...';
  String _osVersion = '';
  int _batteryLevel = 0;
  String _batteryState = 'Unknown';
  int _totalRAM = 0;
  int _freeRAM = 0;

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
  }

  Future<void> _fetchDeviceData() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final battery = Battery();

      String deviceName = 'Unknown Device';
      String osVersion = 'Unknown OS';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceName = iosInfo.name;
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }

      int batteryLevel = await battery.batteryLevel;
      BatteryState state = await battery.batteryState;
      String batteryState = state.name;

      int totalRAM = 0;
      int freeRAM = 0;
      try {
        totalRAM = SysInfo.getTotalPhysicalMemory();
        freeRAM = SysInfo.getFreePhysicalMemory();
      } catch (e) {
        print("Failed to get RAM info: $e");
      }

      if (mounted) {
        setState(() {
          _deviceName = deviceName;
          _osVersion = osVersion;
          _batteryLevel = batteryLevel;
          _batteryState = batteryState;
          _totalRAM = totalRAM;
          _freeRAM = freeRAM;
        });
      }
    } catch (e) {
      print("Error fetching device info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_deviceName, style: theme.textTheme.titleLarge),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Text(_osVersion, style: TextStyle(color: primaryColor, fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: _buildCpuWidget(context, cardColor, primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBatteryWidget(context, cardColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRamWidget(context, cardColor, primaryColor),
                const SizedBox(height: 16),
                _buildStorageWidget(context, cardColor),
                const SizedBox(height: 16),
                _buildNetworkWidget(context, cardColor, primaryColor),
                const SizedBox(height: 80), // padding for bottom nav
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCpuWidget(BuildContext context, Color? cardColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('CPU Cores', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 6.0,
            percent: 1.0,
            center: Text(
              "${Platform.numberOfProcessors}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            progressColor: primaryColor,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.memory, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              Text('Available Cores', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryWidget(BuildContext context, Color? cardColor) {
    double percent = (_batteryLevel / 100).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Battery', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text('$_batteryLevel%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percent,
            progressColor: _batteryLevel < 20 ? Colors.red : Colors.green,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text(_batteryState, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildRamWidget(BuildContext context, Color? cardColor, Color primaryColor) {
    double totalGB = _totalRAM / (1024 * 1024 * 1024);
    double freeGB = _freeRAM / (1024 * 1024 * 1024);
    double usedGB = totalGB - freeGB;
    double percent = totalGB > 0 ? (usedGB / totalGB).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.memory, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RAM Memory', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('${usedGB.toStringAsFixed(1)} GB used of ${totalGB.toStringAsFixed(1)} GB', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Text('${(percent * 100).toInt()}%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: percent,
            progressColor: primaryColor,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            barRadius: const Radius.circular(6),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRamDetail(context, 'Total', '${totalGB.toStringAsFixed(1)} GB'),
              _buildRamDetail(context, 'Used', '${usedGB.toStringAsFixed(1)} GB'),
              _buildRamDetail(context, 'Free', '${freeGB.toStringAsFixed(1)} GB'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRamDetail(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStorageWidget(BuildContext context, Color? cardColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dns, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Storage', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Mocked', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('N/A', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Free Space', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkWidget(BuildContext context, Color? cardColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Network Activity', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Mocked Network', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              Icon(Icons.wifi, color: Theme.of(context).textTheme.bodySmall?.color),
            ],
          ),
        ],
      ),
    );
  }
}
