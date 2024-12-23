import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/divider/bottomsheet_divider.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/workspace/workspace_bloc.dart';

class WorkspaceOptions extends StatelessWidget {
  final Workspace workspace;

  const WorkspaceOptions({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const BottomSheetDivider(),
        _buildOptionTile(
          icon: Icons.delete,
          title: 'Delete Workspace: ${workspace.name}',
          onTap: () => _handleDelete(context),
        ),
        _buildOptionTile(
          icon: Icons.exit_to_app,
          title: 'Leave Workspace: ${workspace.name}',
          onTap: () => _handleLeave(context),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red.shade300),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _handleDelete(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: const Text('Are you sure you want to delete this workspace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
   onPressed: () async {
            // Get the WorkspaceBloc instance
            final workspaceBloc = context.read<WorkspaceBloc>();
            
            // Add delete event and wait for it to complete
            workspaceBloc.add(DeleteWorkspaceEvent(workspaceId: workspace.id));
            
            // Wait for the delete event to be processed
            await Future.delayed(Duration.zero);
            
            // Add get workspaces event after deletion is complete
            workspaceBloc.add(const GetJoinedWorkspacesEvent());
            
            Navigator.pop(context);
          },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleLeave(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Workspace'),
        content: const Text('Are you sure you want to leave this workspace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You have left the workspace")),
              );
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}