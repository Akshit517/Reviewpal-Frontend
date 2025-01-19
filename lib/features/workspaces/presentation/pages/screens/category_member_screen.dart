import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/effects/shimmer_loading_effect.dart';
import '../../../../../core/presentation/widgets/layouts/responsive_layout.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/category/category_member.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/category/member/category_member_bloc.dart';
import '../../blocs/workspace/member/workspace_member_bloc.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';

class CategoryMemberWidget extends StatelessWidget {
  final Workspace workspace;
  final Category category;
  const CategoryMemberWidget({
    super.key,
    required this.workspace,
    required this.category,
  });

  void _showAddMemberDialog(BuildContext context) {
    context
        .read<WorkspaceMemberBloc>()
        .add(GetWorkspaceMembersEvent(workspaceId: workspace.id));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Channel Member'),
        content: SizedBox(
          width: double.maxFinite,
          child: BlocBuilder<WorkspaceMemberBloc, WorkspaceMemberState>(
            builder: (context, state) {
              if (state is WorkspaceMemberLoading) {
                return _buildLoadingShimmer();
              } else if (state is WorkspaceMemberSuccess &&
                  state.members != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.members!.length,
                  itemBuilder: (context, index) {
                    final member = state.members![index];
                    return ListTile(
                      title: Text(member.user.username),
                      subtitle: Text(member.user.email),
                      onTap: () async {
                        if (!context.mounted) return;
                        final categoryMemberBloc =
                            context.read<CategoryMemberBloc>();
                        final completer = Completer<void>();
                        late StreamSubscription subscription;
                        subscription =
                            categoryMemberBloc.stream.listen((state) {
                          if (state is CategoryMemberSuccess ||
                              state is CategoryMemberError) {
                            if (state is CategoryMemberError) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            } else if (state is CategoryMemberSuccess) {
                              categoryMemberBloc.add(GetCategoryMembersEvent(
                                workspaceId: workspace.id,
                                categoryId: category.id,
                              ));
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                            subscription.cancel();
                            completer.complete();
                          }
                        });
                        context.read<CategoryMemberBloc>().add(
                              AddCategoryMemberEvent(
                                workspaceId: workspace.id,
                                categoryId: category.id,
                                userEmail: member.user.email,
                              ),
                            );
                        await completer.future;
                      },
                    );
                  },
                );
              }
              return const Text('No workspace members found');
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workspaceMemberState =
        context.watch<SingleWorkspaceMemberCubit>().state;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Category Members",
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            if (workspaceMemberState.member!.role == 'workspace_admin')
              IconButton(
                onPressed: () => _showAddMemberDialog(context),
                icon: const Icon(Icons.add_rounded),
              )
          ],
        ),
        body: ResponsiveLayout(child: _buildPageContent(workspaceMemberState)));
  }

  Widget _buildPageContent(SingleWorkspaceMemberState workspaceMemberState) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocConsumer<CategoryMemberBloc, CategoryMemberState>(
        listener: (context, state) {
          if (state is CategoryMemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryMemberSuccess && state.members != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: state.members!.map((member) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      child: Text(
                        member.user.username[0].toUpperCase(),
                      ),
                    ),
                    title: Text(member.user.username),
                    onLongPress: () => {
                          if (workspaceMemberState.member!.role ==
                              'workspace_admin')
                            {
                              _handleLongPress(
                                context,
                                workspaceMemberState,
                                member,
                              )
                            }
                        });
              }).toList(),
            );
          } else if (state is CategoryMemberLoading) {
            return _buildLoadingShimmer();
          }
          return const Center(child: Text('No members found'));
        },
      ),
    );
  }

  void _handleLongPress(
    BuildContext context,
    SingleWorkspaceMemberState workspaceMemberState,
    CategoryMember member,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRemoveMember(context, member),
          ],
        ),
      ),
    );
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

  ListTile _buildRemoveMember(BuildContext context, CategoryMember member) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('Remove Member', style: TextStyle(color: Colors.red)),
      onTap: () async {
        if (!context.mounted) return;
        final categoryMemberBloc = context.read<CategoryMemberBloc>();
        final completer = Completer<void>();
        late StreamSubscription subscription;
        subscription = categoryMemberBloc.stream.listen((state) {
          if (state is CategoryMemberSuccess || state is CategoryMemberError) {
            if (!context.mounted) return;
            if (state is CategoryMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is CategoryMemberSuccess) {
              categoryMemberBloc.add(GetCategoryMembersEvent(
                workspaceId: workspace.id,
                categoryId: category.id,
              ));
              Navigator.pop(context);
            }
            subscription.cancel();
            completer.complete();
          }
        });
        context.read<CategoryMemberBloc>().add(RemoveCategoryMemberEvent(
            workspaceId: workspace.id,
            categoryId: category.id,
            userEmail: member.user.email));
        await completer.future;
      },
    );
  }
}
