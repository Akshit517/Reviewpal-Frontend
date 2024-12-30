import 'dart:async';

import 'package:ReviewPal/core/presentation/widgets/pillbox/pillbox.dart';
import 'package:ReviewPal/features/workspaces/domain/entities/workspace/workspace_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/effects/shimmer_loading_effect.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';
import '../../blocs/workspace/member/workspace_member_bloc.dart';

class WorkspaceMemberWidget extends StatefulWidget {
  final Workspace workspace;
  const WorkspaceMemberWidget({super.key, required this.workspace});

  @override
  State<WorkspaceMemberWidget> createState() => _WorkspaceMemberWidgetState();
}

class _WorkspaceMemberWidgetState extends State<WorkspaceMemberWidget> {
  String? _selectedRole;

  @override
  void initState() {
    context
        .read<WorkspaceMemberBloc>()
        .add(GetWorkspaceMembersEvent(workspaceId: widget.workspace.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final singleWorkspaceMemberState =
        context.watch<SingleWorkspaceMemberCubit>().state;
    return Scaffold(
      appBar: _buildAppBar("Workspace Members"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 640;
          final contentWidth =
              isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isTablet) const Spacer(flex: 1),
                Container(
                  width: contentWidth,
                  padding: const EdgeInsets.all(15.0),
                  child: _buildPageContent(
                      constraints, singleWorkspaceMemberState),
                ),
                if (isTablet) const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          height: 1.0,
          thickness: 3.0,
          color: Colors.grey,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPageContent(
    BoxConstraints constraints,
    SingleWorkspaceMemberState singleWorkspaceMemberState,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<WorkspaceMemberBloc, WorkspaceMemberState>(
          listener: (context, state) {
            if (state is WorkspaceMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is WorkspaceMemberSuccess && state.members != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: state.members!.map((member) {
                  final role =
                      member.role == "workspace_admin" ? "ADMIN" : "MEMBER";
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      child: Text(
                        member.user.username[0].toUpperCase(),
                      ),
                    ),
                    title: Text(member.user.username),
                    subtitle: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: PillBox(text: role),
                    ),
                    onLongPress: () => _handleLongPress(
                      context,
                      singleWorkspaceMemberState,
                      member,
                    ),
                  );
                }).toList(),
              );
            } else if (state is WorkspaceMemberLoading) {
              return _buildLoadingShimmer();
            }
            return const Center(child: Text('No members found'));
          },
        ),
      ),
    );
  }

  void _handleLongPress(
    BuildContext context,
    SingleWorkspaceMemberState singleWorkspaceMemberState,
    WorkspaceMember member,
  ) {
    if (singleWorkspaceMemberState.isSuccess == true &&
        singleWorkspaceMemberState.isLoading == false &&
        singleWorkspaceMemberState.member!.role == "workspace_admin") {
      _selectedRole = member.role;

      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 150,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildUpdateRole(context, member),
              _buildRemoveMember(context, member),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => ShimmerLoading(
        isLoading: true,
        child: Container(
          height: 70,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  ListTile _buildRemoveMember(BuildContext context, WorkspaceMember member) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('Remove Member', style: TextStyle(color: Colors.red)),
      onTap: () async {
        if (!context.mounted) return;
        final workspaceMemberBloc = context.read<WorkspaceMemberBloc>();
        final completer = Completer<void>();
        late StreamSubscription subscription;

        subscription = workspaceMemberBloc.stream.listen((state) {
          if (state is WorkspaceMemberSuccess ||
              state is WorkspaceMemberError) {
            if (state is WorkspaceMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is WorkspaceMemberSuccess) {
              workspaceMemberBloc.add(
                  GetWorkspaceMembersEvent(workspaceId: widget.workspace.id));
            }
            completer.complete();
            subscription.cancel();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        });

        workspaceMemberBloc.add(
          RemoveWorkspaceMemberEvent(
            workspaceId: widget.workspace.id,
            email: member.user.email,
          ),
        );

        await completer.future;
      },
    );
  }

  ListTile _buildUpdateRole(BuildContext context, WorkspaceMember member) {
    return ListTile(
      leading: const Icon(Icons.edit),
      title: const Text('Update Role'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Update Role'),
              content: DropdownButton<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(
                    value: 'workspace_admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'workspace_member',
                    child: Text('Member'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                isExpanded: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (!context.mounted) return;
                    final workspaceMemberBloc =
                        context.read<WorkspaceMemberBloc>();
                    final completer = Completer<void>();
                    late StreamSubscription subscription;

                    subscription = workspaceMemberBloc.stream.listen((state) {
                      if (state is WorkspaceMemberSuccess ||
                          state is WorkspaceMemberError) {
                        if (state is WorkspaceMemberError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is WorkspaceMemberSuccess) {
                          workspaceMemberBloc.add(GetWorkspaceMembersEvent(
                              workspaceId: widget.workspace.id));
                        }
                        completer.complete();
                        subscription.cancel();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                    });

                    if (_selectedRole != null) {
                      workspaceMemberBloc.add(
                        UpdateWorkspaceMemberEvent(
                          workspaceId: widget.workspace.id,
                          email: member.user.email,
                          role: _selectedRole!,
                        ),
                      );
                    }

                    await completer.future;
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
