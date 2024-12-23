import 'package:ReviewPal/core/resources/pallete/dark_theme_palette.dart';
import 'package:ReviewPal/features/workspaces/presentation/pages/components/home_screen_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/workspace/workspace_bloc.dart';
import '../components/home_screen_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const GetJoinedWorkspacesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SafeArea(
            child: isMobile
                ? const Row(
                    children: [
                      Expanded(flex:1, child: HomeScreenSidebar(isMobile: true)),
                      VerticalDivider(thickness: 5, color: DarkThemePalette.fillColor),
                      Expanded(flex:4 ,child: HomeScreenMain()),
                    ],
                  )
                : const Row(
                    children: [
                      Expanded(flex: 1, child: HomeScreenSidebar(isMobile: false)),
                      VerticalDivider(thickness: 5, color: DarkThemePalette.fillColor),
                      Expanded(flex: 5, child: HomeScreenMain()),
                    ],
                  ),
          );
        },
      ),
    );
  }
}