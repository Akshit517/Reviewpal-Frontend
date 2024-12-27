import 'package:ReviewPal/core/widgets/pillbox/pillbox.dart';
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
        widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SingleChannelMemberCubit>().state;
    final String key = '${widget.workspace.id}-${widget.category.id}-${widget.channel.id}';
    return CustomExpansionTile(
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => ChannelOptions(
                workspace: widget.workspace,
                category: widget.category,
                channel: widget.channel));
      },
      title: widget.channel.name,
      children: [
        if (state.successStates[key] == true && state.loadingStates[key] == false)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: PillBox(
            text: (state.members[key]?.role == 'reviewer') ? 'REVIEWER' : 'REVIEWEE',
            backgroundColor: (state.members[key]?.role == 'reviewer')
                ? const Color.fromARGB(255, 105, 67, 67)
                : const Color.fromARGB(255, 52, 74, 44),
            textColor: (state.members[key]?.role == 'reviewer')
                ? const Color.fromARGB(255, 255, 184, 184)
                : const Color.fromARGB(255, 217, 253, 173),
            width: double.infinity,
          ),
        ),
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
