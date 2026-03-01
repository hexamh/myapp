import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'hardware_screen.dart';
import 'system_screen.dart';
import 'network_screen.dart';
import 'battery_screen.dart';

class MainLayout extends StatefulWidget {
  final List<Widget>? screens; // Allow injecting mock screens for testing

  const MainLayout({super.key, this.screens});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = widget.screens ?? const [
      DashboardScreen(),
      HardwareScreen(),
      SystemScreen(),
      BatteryScreen(),
      NetworkScreen(), // We'll put Network here based on the icons design
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
                _buildNavItem(1, Icons.smartphone_outlined, Icons.smartphone, 'Device'),
                _buildNavItem(2, Icons.memory_outlined, Icons.memory, 'System'),
                _buildNavItem(3, Icons.battery_full_outlined, Icons.battery_full, 'Battery'),
                _buildNavItem(4, Icons.wifi_outlined, Icons.wifi, 'Network'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor;
    final unselectedColor = theme.bottomNavigationBarTheme.unselectedItemColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: isSelected && index == 3 ? BoxDecoration( // Special styling for battery as per some mocks
              color: selectedColor?.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16)
            ) : null,
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }
}
