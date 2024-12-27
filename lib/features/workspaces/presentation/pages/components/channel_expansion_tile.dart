import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/routes/routes.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/buttons/custom_expansion_tile.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/channel/single_member/single_channel_member_cubit.dart';
import 'channel_options.dart';
import 'home_screen_main.dart';

class ChannelExpansionTile extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  final User user;

  const ChannelExpansionTile(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel, 
      required this.user});

  @override
  State<ChannelExpansionTile> createState() => _ChannelExpansionTileState();
}

class _ChannelExpansionTileState extends State<ChannelExpansionTile> {
  @override
  void initState() {
    super.initState();
    context.read<SingleChannelMemberCubit>().getChannelMember(
        widget.workspace.id,
        widget.category.id,
        widget.channel.id,
        widget.user.email
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SingleChannelMemberCubit>().state;
    final data = state.member;
    return CustomExpansionTile(
      onLongPress: () {
        showBottomSheet(
            context: context,
            builder: (context) => ChannelOptions(
                workspace: widget.workspace,
                category: widget.category,
                channel: widget.channel));
      },
      title: widget.channel.name,
      children: [
        _buildSubSubcategoryOption(
          "Assignment",
          widget.workspace,
          widget.category,
          widget.channel,
          DisplayScreen.assignment,
        ),
        _buildSubSubcategoryOption(
          "Doubts",
          widget.workspace,
          widget.category,
          widget.channel,
          DisplayScreen.doubts,
        ),
      ],
    );
  }

  Widget _buildSubSubcategoryOption(
    String option,
    Workspace workspace,
    Category category,
    Channel channel,
    DisplayScreen type,
  ) {
    final size = MediaQuery.of(context).size;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      minTileHeight: 25,
      minLeadingWidth: 4,
      contentPadding: const EdgeInsets.only(left: 8),
      leading: SvgPicture.asset('assets/icons/hash.svg'),
      title: Text(option,
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              fontWeight: FontWeight.w500)),
      onTap: () {
        final isDesktop = HomeScreenMain.desktopBreakpoint <= size.width;
        final currentPath = GoRouterState.of(context).path;
        if (isDesktop) {
          context.go(
            currentPath ?? CustomNavigationHelper.homePath,
            extra: {
              "workspace": workspace,
              "category": category,
              "channel": channel,
              "type": type
            },
          );
        } else {
          final path = Utils.getPathFromDisplayScreen(type);
          context.push(path, extra: {
            "workspace": workspace,
            "category": category,
            "channel": channel,
            "type": type
          });
        }
      },
    );
  }
}
