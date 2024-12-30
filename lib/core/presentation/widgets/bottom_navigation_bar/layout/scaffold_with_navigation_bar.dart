import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/pallete/dark_theme_palette.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: const Color.fromRGBO(255, 255, 255, 0.1),
        backgroundColor: DarkThemePalette.fillColor,
        destinations: [
          NavigationDestination(
            label: 'Home',
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              colorFilter: selectedIndex == 0
                  ? null
                  : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          NavigationDestination(
            label: 'Notifications',
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              colorFilter: selectedIndex == 1
                  ? null
                  : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          NavigationDestination(
            label: 'Profile',
            icon: Icon(
              Icons.person_2_rounded,
              color: selectedIndex == 2 ? Colors.white : Colors.grey,
            ),
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
