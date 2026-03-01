import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  String _osName = 'Loading...';
  String _osVersion = '';
  String _apiLevel = '';
  String _buildId = '';
  String _kernelVersion = '';
  String _securityPatch = '';
  String _totalRAM = '';
  String _usedRAM = '';

  @override
  void initState() {
    super.initState();
    _fetchSystemInfo();
  }

  Future<void> _fetchSystemInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    String osName = 'Unknown';
    String osVersion = '';
    String apiLevel = '';
    String buildId = 'Unknown';
    String kernelVersion = SysInfo.kernelVersion;
    String securityPatch = 'Unknown';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        osName = 'Android ${androidInfo.version.release}';
        apiLevel = 'API Level ${androidInfo.version.sdkInt}';
        buildId = androidInfo.id;
        securityPatch = androidInfo.version.securityPatch ?? 'Unknown';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        osName = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        buildId = 'Unknown'; // no exact match for iOS
        securityPatch = 'Unknown';
      }
    } catch (e) {
      print("Error fetching system info: $e");
    }

    int totalRAMBytes = 0;
    int freeRAMBytes = 0;
    try {
      totalRAMBytes = SysInfo.getTotalPhysicalMemory();
      freeRAMBytes = SysInfo.getFreePhysicalMemory();
    } catch (e) {
      print("Error fetching RAM info: $e");
    }

    double totalGB = totalRAMBytes / (1024 * 1024 * 1024);
    double freeGB = freeRAMBytes / (1024 * 1024 * 1024);
    double usedGB = totalGB - freeGB;

    if (mounted) {
      setState(() {
        _osName = osName;
        _osVersion = osVersion;
        _apiLevel = apiLevel;
        _buildId = buildId;
        _kernelVersion = kernelVersion;
        _securityPatch = securityPatch;
        _totalRAM = '${totalGB.toStringAsFixed(1)} GB';
        _usedRAM = '${usedGB.toStringAsFixed(1)} GB';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildAndroidVersionHero(context, primaryColor),
            const SizedBox(height: 24),
            _buildStatsGrid(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildInfoList(context, cardColor),
            const SizedBox(height: 24),
            _buildUpdateCTA(context, primaryColor),
            const SizedBox(height: 80), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidVersionHero(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 4),
          ),
          child: Center(
            child: Icon(Platform.isAndroid ? Icons.android : Icons.apple, size: 64, color: Platform.isAndroid ? Colors.green : Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
        Text(_osName, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_apiLevel.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(_apiLevel, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, Color? cardColor, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Icon(Icons.memory, color: primaryColor, size: 32),
                const SizedBox(height: 8),
                Text('RAM USAGE', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('$_usedRAM / $_totalRAM', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Icon(Icons.smartphone, color: primaryColor, size: 32),
                const SizedBox(height: 8),
                Text('UPTIME', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('N/A', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoList(BuildContext context, Color? cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildInfoItem(context, 'Build ID', _buildId, trailingIcon: Icons.content_copy),
          _buildInfoItem(context, 'Kernel Version', _kernelVersion, isMono: true),
          _buildInfoItem(context, 'Security Patch', _securityPatch, icon: Icons.verified_user, iconColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, {bool isLast = false, IconData? trailingIcon, IconData? icon, Color? iconColor, bool isMono = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: iconColor),
              ]
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: isMono ? 'monospace' : null,
                )),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, size: 20, color: Theme.of(context).textTheme.bodySmall?.color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCTA(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).cardTheme.color!.withValues(alpha: 0.8), primaryColor.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.system_update, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('System Update', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('Check for latest software updates', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
            icon: const Text('Check Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            label: const Icon(Icons.arrow_forward, size: 16),
          ),
        ],
      ),
    );
  }
}
