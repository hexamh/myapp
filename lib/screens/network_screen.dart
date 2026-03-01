import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final NetworkInfo _networkInfo = NetworkInfo();
  String _wifiName = 'Loading...';
  String _wifiBSSID = 'Loading...';
  String _wifiIP = 'Loading...';
  String _wifiIPv6 = 'Loading...';
  String _wifiSubmask = 'Loading...';
  String _wifiBroadcast = 'Loading...';
  String _wifiGateway = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchNetworkInfo();
  }

  Future<void> _fetchNetworkInfo() async {
    String? wifiName;
    String? wifiBSSID;
    String? wifiIP;
    String? wifiIPv6;
    String? wifiSubmask;
    String? wifiBroadcast;
    String? wifiGateway;

    try {
      wifiName = await _networkInfo.getWifiName();
      wifiBSSID = await _networkInfo.getWifiBSSID();
      wifiIP = await _networkInfo.getWifiIP();
      wifiIPv6 = await _networkInfo.getWifiIPv6();
      wifiSubmask = await _networkInfo.getWifiSubmask();
      wifiBroadcast = await _networkInfo.getWifiBroadcast();
      wifiGateway = await _networkInfo.getWifiGatewayIP();
    } catch (e) {
      debugPrint("Failed to get network info: $e");
    }

    if (mounted) {
      setState(() {
        _wifiName = wifiName ?? 'Not Connected';
        _wifiBSSID = wifiBSSID ?? 'N/A';
        _wifiIP = wifiIP ?? 'N/A';
        _wifiIPv6 = wifiIPv6 ?? 'N/A';
        _wifiSubmask = wifiSubmask ?? 'N/A';
        _wifiBroadcast = wifiBroadcast ?? 'N/A';
        _wifiGateway = wifiGateway ?? 'N/A';
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
        title: const Text('Network Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWifiSection(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildMobileNetworkSection(context, cardColor, primaryColor),
            const SizedBox(height: 24),
            _buildSpeedTestTeaser(context, primaryColor),
            const SizedBox(height: 80), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildWifiSection(BuildContext context, Color? cardColor, Color primaryColor) {
    bool isConnected = _wifiName != 'Not Connected' && _wifiName != 'Loading...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Wi-Fi Connection', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isConnected ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isConnected ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: isConnected ? Colors.green : Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(isConnected ? 'CONNECTED' : 'DISCONNECTED', style: TextStyle(color: isConnected ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              _buildNetworkRow(context, Icons.wifi, Colors.blue, 'SSID', _wifiName),
              _buildNetworkRow(context, Icons.router, Colors.purple, 'BSSID', _wifiBSSID, isMono: true),
              _buildNetworkRow(context, Icons.dns, Colors.cyan, 'IP Address', _wifiIP, isMono: true),
              _buildNetworkRow(context, Icons.dns, Colors.cyan, 'IPv6 Address', _wifiIPv6, isMono: true),
              _buildNetworkRow(context, Icons.settings_ethernet, Colors.teal, 'Submask', _wifiSubmask, isMono: true),
              _buildNetworkRow(context, Icons.cell_tower, Colors.indigo, 'Broadcast', _wifiBroadcast, isMono: true),
              _buildNetworkRow(context, Icons.alt_route, Colors.orange, 'Gateway', _wifiGateway, isMono: true, isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkRow(BuildContext context, IconData icon, Color color, String label, String value, {bool isLast = false, bool isMono = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: isMono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNetworkSection(BuildContext context, Color? cardColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mobile Network', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: Text('Settings', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.indigo.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.cell_tower, color: Colors.indigo),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Operator', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                        Text('N/A', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.five_g, color: Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.white70)),
                        Text('N/A', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedTestTeaser(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.surface, primaryColor.withValues(alpha: 0.1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Test Network Speed', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Check your download & upload latency', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.speed, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
