import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/routes/routes.dart';
import '../../../../../core/presentation/widgets/divider/bottomsheet_divider.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/channel/channel_bloc/channel_bloc.dart';
import '../../blocs/channel/member/channel_member_bloc.dart';
import '../../blocs/channel/single_member/single_channel_member_cubit.dart';

class ChannelOptions extends StatelessWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const ChannelOptions(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel});

  @override
  Widget build(BuildContext context) {
    final channelMemberState = context.watch<SingleChannelMemberCubit>().state;
    final key = '${workspace.id}-${category.id}-${channel.id}';
    return Wrap(
      children: [
        const BottomSheetDivider(),
        if (channelMemberState.successStates[key] == true &&
            channelMemberState.members[key]!.role == 'reviewer' &&
            channelMemberState.loadingStates[key] == false)
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Assignment"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Assignment"),
                  content: const Text(
                      "Are you sure you want to delete this assignment?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        context.read<ChannelBloc>().add(DeleteChannelEvent(
                            workspaceId: workspace.id,
                            categoryId: category.id,
                            channelId: channel.id));
                        Navigator.pop(context);
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
        if (channelMemberState.successStates[key] == true &&
            channelMemberState.members[key]!.role == 'reviewer' &&
            channelMemberState.loadingStates[key] == false)
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Edit Assignment"),
            onTap: () {
              context
                  .push(CustomNavigationHelper.addAssignmentScreenPath, extra: {
                'workspace': workspace,
                'category': category,
                'channel': channel,
                'forUpdateAssignment': true
              });
              Navigator.pop(context);
            },
          ),
        ListTile(
          leading: const Icon(Icons.groups_2_rounded),
          title: const Text("View Members"),
          onTap: () {
            context.read<ChannelMemberBloc>().add(GetChannelMembersEvent(
                workspaceId: workspace.id,
                categoryId: category.id,
                channelId: channel.id));
            context.push(CustomNavigationHelper.channelMembersPath, extra: {
              'workspace': workspace,
              'category': category,
              'channel': channel,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
