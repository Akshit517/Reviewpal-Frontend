import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../blocs/workspace/workspace_bloc.dart';
import 'create_category_dialog.dart';
import 'workspace_header.dart';
import 'categories_list.dart';

class CategoriesSidebar extends StatelessWidget {
  final bool isDesktop;

  const CategoriesSidebar({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, workspaceState) {
        if (workspaceState is WorkspaceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (workspaceState is WorkspaceLoaded) {
          return Column(
            children: [
              WorkspaceHeader(
                name: workspaceState.workspace.name,
                isDesktop: isDesktop,
              ),
              const Divider(
                thickness: 4,
                color: DarkThemePalette.fillColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: (){
                          _showAddCategoryDialog(context, workspaceState);
                        }, 
                        icon: SvgPicture.asset(
                          "assets/icons/category_add.svg",
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: (){}, 
                        icon: SvgPicture.asset(
                          "assets/icons/graph_view.svg",
                        )
                      ),
                    )
                  ],   
                ),
              ),
              Expanded(
                child: CategoriesList(workspace: workspaceState.workspace),
              ),
            ],
          );
        } else if (workspaceState is WorkspaceError) {
          return _buildErrorView(context, workspaceState.message);
        } else {
          return _buildNoWorkspaceView();
        }
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context, WorkspaceLoaded workspaceState) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: CreateCategoryDialog(workspaceId: workspaceState.workspace.id, ctx: ctx),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
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
          Center(child: Text("Error: $message")),
        ],
      ),
    );
  }

  Widget _buildNoWorkspaceView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("≧◉◡◉≦", style: TextStyle(fontSize: 40)),
        SizedBox(height: 4),
        Text("No Workspace Selected!!!"),
      ],
    );
  }
}
