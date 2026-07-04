import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabSelected;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      unselectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      currentIndex: selectedIndex,
      onTap: onTabSelected,
      items: [
        _buildNavigationBarItem(context, Icons.home_outlined, 'Home', 0),
        _buildNavigationBarItem(
          context,
          Icons.people_alt_outlined,
          'Connections',
          1,
        ),
        _buildNavigationBarItem(
          context,
          Icons.calendar_today_outlined,
          'Calendar',
          2,
        ),
        _buildNavigationBarItem(
          context,
          Icons.account_circle_outlined,
          'My Profile',
          3,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      label: label,
    );
  }
}
