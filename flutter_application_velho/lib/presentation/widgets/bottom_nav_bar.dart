import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: AppColors.textSecondary,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      iconSize: 28,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.family_restroom_rounded),
          label: 'Família',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: 'Amigos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emergency_rounded),
          label: 'Emergência',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Config.',
        ),
      ],
    );
  }
}
