import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../../core/widgets/buttons/inkwell_button.dart';
import '../../../../../core/widgets/effects/shimmer_loading_effect.dart';
import '../../../../../core/widgets/image/universal_image.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/workspace/workspace_bloc.dart';
import 'add_workspace_dialog.dart';

class HomeScreenSidebar extends StatelessWidget {
  final bool isMobile;

  const HomeScreenSidebar({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<WorkspaceBloc, WorkspaceState>(
              listenWhen: (previous, current) => current is WorkspaceError,
              listener: (context, state) {
                if (state is WorkspaceError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is WorkspacesLoading ||
                  current is WorkspacesLoaded ||
                  current is WorkspaceError,
              builder: (context, state) {
                if (state is WorkspacesLoaded) {
                  return ListView.builder(
                    itemCount: state.workspaces.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CircleAvatar(
                        radius: isMobile ? 25 : 35,
                        child: InkWell(
                          onLongPress: () {
                            _showWorkspaceOptions(context);
                          },
                          onTap: () {
                            context.read<WorkspaceBloc>().add(
                              GetWorkspaceEvent(
                                workspaceId: state.workspaces[index].id));

                            context.read<CategoryBloc>().add(
                                GetCategoriesEvent(
                                    workspaceId: state.workspaces[index].id));
                          },
                          child: ClipOval(
                            child: UniversalImage(
                              imageUrl: state.workspaces[index].icon,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ShimmerLoading(
                      isLoading: true,
                      child: CircleAvatar(
                        radius: isMobile ? 25 : 35,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWellButton.circular(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => const AddWorkspaceDialog());
              },
              backgroundColor: DarkThemePalette.secondaryDarkGray,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkspaceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            const Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 1,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.red.shade300,
              ),
              title: const Text('Delete Workspace'),
              onTap: () {
                // Handle delete workspace action
                Navigator.pop(context);
                _deleteWorkspace(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red.shade300,
              ),
              title: const Text('Leave Workspace'),
              onTap: () {
                // Handle leave workspace action
                Navigator.pop(context);
                _leaveWorkspace(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteWorkspace(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Workspace'),
          content:
              const Text('Are you sure you want to delete this workspace?'),
          actions: [
            TextButton(
              onPressed: () {
                // Implement actual deletion logic here
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement deletion logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Workspace deleted successfully")),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _leaveWorkspace(BuildContext context) {
    // Implement leave workspace logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Workspace'),
          content: const Text('Are you sure you want to leave this workspace?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You have left the workspace")),
                );
              },
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
  }
}
