import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/widgets/divider/bottomsheet_divider.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';
import '../../blocs/workspace/workspace_bloc/workspace_bloc.dart';

class WorkspaceOptions extends StatefulWidget {
  final Workspace workspace;
  final User user;

  const WorkspaceOptions(
      {super.key, required this.workspace, required this.user});

  @override
  State<WorkspaceOptions> createState() => _WorkspaceOptionsState();
}

class _WorkspaceOptionsState extends State<WorkspaceOptions> {
  @override
  void initState() {
    context
        .read<SingleWorkspaceMemberCubit>()
        .getWorkspaceMember(widget.workspace.id, widget.user.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final singleWorkspaceMemberState =
        context.watch<SingleWorkspaceMemberCubit>().state;
    return Wrap(
      children: [
        const BottomSheetDivider(),
        if (singleWorkspaceMemberState.isSuccess == true &&
            singleWorkspaceMemberState.isLoading == false &&
            singleWorkspaceMemberState.member!.role == "workspace_admin")
          _buildOptionTile(
            icon: Icons.delete,
            title: 'Delete Workspace: ${widget.workspace.name}',
            onTap: () => _handleDelete(context),
          ),
        // _buildOptionTile(
        //   icon: Icons.exit_to_app,
        //   title: 'Leave Workspace: ${widget.workspace.name}',
        //   onTap: () => _handleLeave(context),
        // ),
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
              final workspaceBloc = context.read<WorkspaceBloc>();
              final completer = Completer<void>();
              late StreamSubscription subscription;
              subscription = workspaceBloc.stream.listen((state) {
                if (state is WorkspaceDeleted) {
                  workspaceBloc.add(const GetJoinedWorkspacesEvent());
                  completer.complete();
                  subscription.cancel();
                } else if (state is WorkspaceError) {
                  completer.completeError(state.message);
                  subscription.cancel();
                }
              });
              workspaceBloc
                  .add(DeleteWorkspaceEvent(workspaceId: widget.workspace.id));
              await completer.future;
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
