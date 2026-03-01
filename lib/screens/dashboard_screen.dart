import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'apps_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                Text('iPhone 14 Pro', style: theme.textTheme.titleLarge),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Text('iOS 16.5', style: TextStyle(color: primaryColor, fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    Text('Uptime: 4d 12h', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
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
            child: Text('CPU Usage', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 6.0,
            percent: 0.32,
            center: Text(
              "32%",
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
              const Icon(Icons.arrow_downward, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Text('Normal load', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryWidget(BuildContext context, Color? cardColor) {
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
          Text('84%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: 0.84,
            progressColor: Colors.green,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text('Discharging • 5h 20m left', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildRamWidget(BuildContext context, Color? cardColor, Color primaryColor) {
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
                child: Icon(Icons.analytics, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RAM Memory', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('4.2 GB used of 6.0 GB', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Text('70%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: 0.70,
            progressColor: primaryColor,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            barRadius: const Radius.circular(6),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRamDetail(context, 'Active', '2.1 GB'),
              _buildRamDetail(context, 'Wired', '1.4 GB'),
              _buildRamDetail(context, 'Free', '1.8 GB'),
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
                  Text('128 GB Total', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('45.2 GB', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Free Space', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(flex: 40, child: Container(height: 12, color: Theme.of(context).primaryColor)),
                Expanded(flex: 15, child: Container(height: 12, color: Colors.purple)),
                Expanded(flex: 10, child: Container(height: 12, color: Colors.amber)),
                Expanded(flex: 35, child: Container(height: 12, color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStorageLegend(context, 'Apps (51GB)', Theme.of(context).primaryColor, isApps: true),
              _buildStorageLegend(context, 'Media (19GB)', Colors.purple),
              _buildStorageLegend(context, 'System (12GB)', Colors.amber),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStorageLegend(BuildContext context, String label, Color color, {bool isApps = false}) {
    if (isApps) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AppsScreen()),
          );
        },
        child: Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, decoration: TextDecoration.underline)),
          ],
        ),
      );
    }
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
      ],
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
                  Text('Wi-Fi: Home_5G', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              Icon(Icons.wifi, color: Theme.of(context).textTheme.bodySmall?.color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Download', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '45.2 ', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                          TextSpan(text: 'Mb/s', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                        ]
                      )
                    )
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upload', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '12.8 ', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                          TextSpan(text: 'Mb/s', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                        ]
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Simple mock graph line
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: _MockGraphPainter(primaryColor),
            ),
          )
        ],
      ),
    );
  }
}

class _MockGraphPainter extends CustomPainter {
  final Color color;
  _MockGraphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.7, size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.6, size.width * 0.6, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.5, size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
    
    // Add gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
      
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
