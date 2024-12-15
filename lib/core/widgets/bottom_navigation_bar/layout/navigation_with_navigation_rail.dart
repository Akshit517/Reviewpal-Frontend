import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resources/pallete/dark_theme_palette.dart';

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
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
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            backgroundColor: DarkThemePalette.fillColor,
            indicatorColor: const Color.fromRGBO(255, 255, 255, 0.1),
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                label: const Text('Home'),
                icon: SvgPicture.asset('assets/icons/home.svg',
                    colorFilter: selectedIndex == 0
                        ? null
                        : const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
              ),
              NavigationRailDestination(
                label: const Text('Notifications'),
                icon: SvgPicture.asset(
                  'assets/icons/notifications.svg',
                  colorFilter: selectedIndex == 1
                      ? null
                      : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
              ),
              NavigationRailDestination(
                label: const Text('Profile'),
                icon: Icon(
                  Icons.person_2_rounded,
                  color: selectedIndex == 2 ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.grey,),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
