import 'package:flutter/material.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Manager'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Pop to return to previous screen if pushed
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Select', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context, primaryColor),
          _buildFilterPills(context, primaryColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'User Apps (42)', primaryColor),
                  _buildAppItem(context, Icons.chat, Colors.green, 'WhatsApp Messenger', 'v2.23.12.78', '145 MB'),
                  _buildAppItem(context, Icons.camera_alt, Colors.pink, 'Instagram', 'v290.0.0.13', '210 MB'),
                  _buildAppItem(context, Icons.public, Colors.blue, 'Facebook', 'v418.0.0.33', '305 MB'),
                  _buildAppItem(context, Icons.play_circle, Colors.greenAccent[700]!, 'Spotify: Music and Podcasts', 'v8.8.44.52', '98 MB', isBlackBg: true),
                  _buildAppItem(context, Icons.movie, Colors.red, 'Netflix', 'v8.72.1', '112 MB'),
                  
                  _buildSectionHeader(context, 'System Apps (12)', primaryColor),
                  _buildAppItem(context, Icons.settings, Colors.grey, 'Settings', 'v13.0.0', '45 MB', isSystem: true),
                  _buildAppItem(context, Icons.camera_front, Colors.grey, 'Camera', 'v2.1.0', '25 MB', isSystem: true),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search installed apps',
            hintStyle: Theme.of(context).textTheme.bodySmall,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).textTheme.bodySmall?.color),
            suffixIcon: Icon(Icons.mic, color: Theme.of(context).textTheme.bodySmall?.color),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPills(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildPill(context, 'All Apps', true, primaryColor),
          const SizedBox(width: 8),
          _buildPill(context, 'User Installed', false, primaryColor),
          const SizedBox(width: 8),
          _buildPill(context, 'System', false, primaryColor),
          const SizedBox(width: 8),
          _buildPill(context, 'Large Size', false, primaryColor),
        ],
      ),
    );
  }

  Widget _buildPill(BuildContext context, String label, bool isSelected, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? primaryColor : Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('SORT BY', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(width: 4),
              Icon(Icons.sort, color: primaryColor, size: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAppItem(BuildContext context, IconData icon, Color color, String name, String version, String size, {bool isBlackBg = false, bool isSystem = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color?.withValues(alpha: isSystem ? 0.5 : 1.0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent), // hover border handled natively or ignored in mobile
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isBlackBg ? Colors.black : color,
              borderRadius: BorderRadius.circular(12),
              gradient: isBlackBg ? null : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withValues(alpha: 0.8), color],
              ),
            ),
            child: Icon(icon, color: isBlackBg ? color : Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(version, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                    const SizedBox(width: 6),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor.withValues(alpha: 0.2), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(size, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          if (isSystem)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('SYSTEM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodySmall?.color)),
            ),
          if (!isSystem)
            Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodySmall?.color),
        ],
      ),
    );
  }
}
