import 'package:ReviewPal/core/resources/pallete/dark_theme_palette.dart';
import 'package:ReviewPal/features/workspaces/presentation/pages/components/home_screen_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../blocs/workspace/workspace_bloc.dart';
import '../components/workspace_home_widget.dart';

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
                ? Row(
                    children: [
                      Expanded(flex:1, child: HomeScreenSidebar(isMobile: isMobile)),
                      const VerticalDivider(thickness: 5, color: DarkThemePalette.fillColor),
                      // Main content area for mobile
                      Expanded(flex:4 ,child: _buildMainContent()),
                    ],
                  )
                : Row(
                    children: [
                      // Sidebar for desktop
                      const Expanded(flex: 1, child: HomeScreenSidebar(isMobile: false)),
                      // Main content area for desktop
                      Expanded(flex: 5, child: _buildMainContent()),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, state) {
        if (state is WorkspaceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkspaceLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        state.workspace.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                        )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        onPressed: (){}, 
                        icon: SvgPicture.asset(
                          "assets/icons/settings.svg",
                        )),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 4, color: DarkThemePalette.fillColor,),
              Expanded(
                flex: 8,
                child: WorkspaceHomeWidget(workspaceId: state.workspace.id,),
              )
          ]);
        } else if (state is WorkspaceError) {
          return RefreshIndicator(
            backgroundColor: DarkThemePalette.fillColor,
            color: Colors.grey,
            onRefresh: () async {
              context.read<WorkspaceBloc>().add(const GetJoinedWorkspacesEvent());
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 200),
                Center(child: Text("Error: ${state.message}"))],
            ),
          );
        } else {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("≧◉◡◉≦", style: TextStyle(fontSize: 40),),
              SizedBox(height: 4,),
              Text("No Workspace Selected!!!")
            ],
          );
        }
      },
    );
  }
}