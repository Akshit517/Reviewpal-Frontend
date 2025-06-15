import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/buttons/custom_expansion_tile.dart';
import '../../../../../core/presentation/widgets/effects/shimmer_loading_effect.dart';
import '../../../../../core/presentation/widgets/layouts/responsive_layout.dart';
import '../../../../../core/presentation/widgets/pillbox/pillbox.dart';
import '../../../../../core/presentation/widgets/text_field/text_field_header.dart';
import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/channel/channel_member.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/channel/member/channel_member_bloc.dart';
import '../../blocs/channel/single_member/single_channel_member_cubit.dart';
import '../../blocs/workspace/member/workspace_member_bloc.dart';

class ChannelMemberWidget extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  const ChannelMemberWidget(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel});

  @override
  State<ChannelMemberWidget> createState() => _ChannelMemberWidgetState();
}

class _ChannelMemberWidgetState extends State<ChannelMemberWidget> {
  final TextEditingController _teamController = TextEditingController();
  String? _selectedRole;

  void _showAddMemberDialog() {
    context
        .read<WorkspaceMemberBloc>()
        .add(GetWorkspaceMembersEvent(workspaceId: widget.workspace.id));

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
                return Column(
                  children: [
                    const TextFieldHeader(text: 'Team'),
                    TextFormFieldWidget(
                      controller: _teamController,
                      hintText: 'Enter team...',
                      haveObscureText: false,
                      haveSuffixIconObscure: false,
                    ),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.members!.length,
                      itemBuilder: (context, index) {
                        final member = state.members![index];
                        return ListTile(
                          title: Text(member.user.username),
                          subtitle: Text(member.user.email),
                          onTap: () async {
                            if (!context.mounted) return;
                            final channelMemberBloc =
                                context.read<ChannelMemberBloc>();
                            final completer = Completer<void>();
                            late StreamSubscription subscription;
                            subscription =
                                channelMemberBloc.stream.listen((state) {
                              if (state is ChannelMemberSuccess ||
                                  state is ChannelMemberError) {
                                if (state is ChannelMemberError) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                } else if (state is ChannelMemberSuccess) {
                                  channelMemberBloc.add(GetChannelMembersEvent(
                                      workspaceId: widget.workspace.id,
                                      categoryId: widget.category.id,
                                      channelId: widget.channel.id));
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                                subscription.cancel();
                                completer.complete();
                              }
                            });
                            context.read<ChannelMemberBloc>().add(
                                  AddChannelMemberEvent(
                                    workspaceId: widget.workspace.id,
                                    categoryId: widget.category.id,
                                    channelId: widget.channel.id,
                                    userEmail: member.user.email,
                                    team: _teamController.text,
                                    role: 'reviewee',
                                  ),
                                );
                            await completer.future;
                            _teamController.clear();
                          },
                        );
                      },
                    ),
                  ],
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
    final singleChannelMemberState =
        context.watch<SingleChannelMemberCubit>().state;
    final String key =
        '${widget.workspace.id}-${widget.category.id}-${widget.channel.id}';
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Channel Members",
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
            if (singleChannelMemberState.members[key]!.role == 'reviewer' &&
                singleChannelMemberState.loadingStates[key] == false &&
                singleChannelMemberState.successStates[key] == true)
              IconButton(
                onPressed: _showAddMemberDialog,
                icon: const Icon(Icons.add_rounded),
              )
          ],
        ),
        body: ResponsiveLayout(
            child: _buildPageContent(singleChannelMemberState, key)));
  }

  Widget _buildPageContent(
      SingleChannelMemberState singleChannelMemberState, String key) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocConsumer<ChannelMemberBloc, ChannelMemberState>(
        listener: (context, state) {
          if (state is ChannelMemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChannelMemberSuccess && state.membersByTeam != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: state.membersByTeam!.entries.map((entry) {
                final team = entry.key;
                final members = entry.value;
                return CustomExpansionTile(
                  title: team!.name,
                  children: members.map((member) {
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
                        child: PillBox(
                          text: member.role.toUpperCase(),
                          backgroundColor: (member.role == "reviewer")
                              ? const Color.fromARGB(255, 105, 67, 67)
                              : const Color.fromARGB(255, 52, 74, 44),
                          textColor: (member.role == "reviewer")
                              ? const Color.fromARGB(255, 255, 184, 184)
                              : const Color.fromARGB(255, 217, 253, 173),
                        ),
                      ),
                      onLongPress: () => {
                        if (singleChannelMemberState.members[key]?.role ==
                                "reviewer" &&
                            singleChannelMemberState.loadingStates[key] ==
                                false &&
                            singleChannelMemberState.successStates[key] == true)
                          {
                            _handleLongPress(
                              context,
                              singleChannelMemberState,
                              member,
                            )
                          }
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            );
          } else if (state is ChannelMemberLoading) {
            return _buildLoadingShimmer();
          }
          return const Center(child: Text('No members found'));
        },
      ),
    );
  }

  void _handleLongPress(
    BuildContext context,
    SingleChannelMemberState singleChannelMemberState,
    ChannelMember member,
  ) {
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

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
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

  ListTile _buildRemoveMember(BuildContext context, ChannelMember member) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('Remove Member', style: TextStyle(color: Colors.red)),
      onTap: () async {
        if (!context.mounted) return;
        final channelMemberBloc = context.read<ChannelMemberBloc>();
        final completer = Completer<void>();
        late StreamSubscription subscription;
        subscription = channelMemberBloc.stream.listen((state) {
          if (state is ChannelMemberSuccess || state is ChannelMemberError) {
            if (!context.mounted) return;
            if (state is ChannelMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ChannelMemberSuccess) {
              channelMemberBloc.add(GetChannelMembersEvent(
                  workspaceId: widget.workspace.id,
                  categoryId: widget.category.id,
                  channelId: widget.channel.id));
              Navigator.pop(context);
            }
            subscription.cancel();
            completer.complete();
          }
        });
        context.read<ChannelMemberBloc>().add(RemoveChannelMemberEvent(
            workspaceId: widget.workspace.id,
            categoryId: widget.category.id,
            channelId: widget.channel.id,
            userEmail: member.user.email));
        await completer.future;
      },
    );
  }

  ListTile _buildUpdateRole(BuildContext context, ChannelMember member) {
    return ListTile(
      leading: const Icon(Icons.edit),
      title: const Text('Update Role'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Update Role'),
              content: Column(
                children: [
                  const TextFieldHeader(text: 'Team'),
                  TextFormFieldWidget(
                    controller: _teamController,
                    hintText: 'Enter team...',
                    haveObscureText: false,
                    haveSuffixIconObscure: false,
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(
                        value: 'reviewer',
                        child: Text('Reviewer'),
                      ),
                      DropdownMenuItem(
                        value: 'reviewee',
                        child: Text('Reviewee'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                    isExpanded: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (!context.mounted) return;
                    final channelMemberBloc = context.read<ChannelMemberBloc>();
                    final completer = Completer<void>();
                    late StreamSubscription subscription;
                    subscription = channelMemberBloc.stream.listen((state) {
                      if (state is ChannelMemberSuccess ||
                          state is ChannelMemberError) {
                        if (state is ChannelMemberError) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is ChannelMemberSuccess) {
                          channelMemberBloc.add(GetChannelMembersEvent(
                              workspaceId: widget.workspace.id,
                              categoryId: widget.category.id,
                              channelId: widget.channel.id));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                        subscription.cancel();
                        completer.complete();
                      }
                    });
                    if (_selectedRole != null) {
                      context.read<ChannelMemberBloc>().add(
                          UpdateChannelMemberEvent(
                              workspaceId: widget.workspace.id,
                              categoryId: widget.category.id,
                              channelId: widget.channel.id,
                              userEmail: member.user.email,
                              team: _teamController.text,
                              role: _selectedRole!));
                    }
                    await completer.future;
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    _teamController.clear();
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
