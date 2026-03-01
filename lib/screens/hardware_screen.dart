import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {
  String _model = 'Loading...';
  String _osVersion = '';
  String _architecture = '';
  String _cores = '';

  @override
  void initState() {
    super.initState();
    _fetchHardwareInfo();
  }

  Future<void> _fetchHardwareInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String model = 'Unknown';
    String osVersion = 'Unknown';
    String architecture = 'Unknown';
    String cores = Platform.numberOfProcessors.toString();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        model = '${androidInfo.manufacturer} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release}';
        architecture = androidInfo.supportedAbis.isNotEmpty ? androidInfo.supportedAbis.join(', ') : 'Unknown';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.name;
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        architecture = iosInfo.utsname.machine;
      }
    } catch (e) {
      print("Error fetching hardware info: $e");
    }

    if (mounted) {
      setState(() {
        _model = model;
        _osVersion = osVersion;
        _architecture = architecture;
        _cores = cores;
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
        title: const Text('Device Specs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeroSection(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildProcessorSection(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildDisplaySection(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildCameraSection(context, cardColor, primaryColor),
            const SizedBox(height: 80), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Color? cardColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.withValues(alpha: 0.2), primaryColor.withValues(alpha: 0.05)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.smartphone, size: 40, color: primaryColor),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_model, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_osVersion, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProcessorSection(BuildContext context, Color? cardColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.memory, color: primaryColor),
            const SizedBox(width: 8),
            Text('Processor', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              _buildSpecRow(context, 'Cores', '$_cores Cores', 'Architecture', _architecture),
              Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSpecRow(BuildContext context, String label1, String value1, String label2, String value2) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _buildSpecCell(context, label1, value1)),
          VerticalDivider(width: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          Expanded(child: _buildSpecCell(context, label2, value2)),
        ],
      ),
    );
  }

  Widget _buildSpecCell(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDisplaySection(BuildContext context, Color? cardColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.screenshot_monitor, color: primaryColor),
            const SizedBox(width: 8),
            Text('Display', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              _buildListTile(context, 'Resolution', 'N/A'),
              _buildListTile(context, 'Pixel Density', 'N/A'),
              _buildListTile(context, 'Refresh Rate', 'N/A', isPrimary: true, primaryColor: primaryColor),
              _buildListTile(context, 'Brightness (Peak)', 'N/A', isLast: true),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildListTile(BuildContext context, String title, String value, {bool isLast = false, bool isPrimary = false, Color? primaryColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          isPrimary
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor?.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: primaryColor!.withValues(alpha: 0.2)),
                  ),
                  child: Text(value, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
                )
              : Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCameraSection(BuildContext context, Color? cardColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_camera, color: primaryColor),
            const SizedBox(width: 8),
            Text('Cameras', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        _buildCameraCard(context, cardColor, primaryColor, Icons.lens, 'Main', 'N/A', 'N/A'),
      ],
    );
  }

  Widget _buildCameraCard(BuildContext context, Color? cardColor, Color primaryColor, IconData icon, String title, String subtitle, String focalLength) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(focalLength, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
