import 'package:flutter/material.dart';

import 'categories_sidebar.dart';
import 'content_view.dart';

class HomeScreenMain extends StatelessWidget {
  static const double _desktopBreakpoint = 1200;
  static const double _sidebarWidth = 400.0;

  const HomeScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

        return Row(
          children: [
            SizedBox(
              width: isDesktop ? _sidebarWidth : constraints.maxWidth,
              child: CategoriesSidebar(isDesktop: isDesktop),
            ),
            if (isDesktop)
              const Expanded(
                child: ContentView(),
              ),
          ],
        );
      },
    );
  }
}
