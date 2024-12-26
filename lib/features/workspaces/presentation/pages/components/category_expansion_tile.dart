import 'package:ReviewPal/features/workspaces/presentation/pages/screens/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/effects/shimmer_loading_effect.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/channel/channel_bloc/channel_bloc.dart';
import '../screens/doubt_screen.dart';
import 'category_options.dart';
import 'custom_expansion_tile.dart';

class CategoryExpansionTile extends StatefulWidget {
  final Workspace workspace;
  final Category category;

  const CategoryExpansionTile(
      {super.key, required this.category, required this.workspace});

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  @override
  void initState() {
    super.initState();
    context.read<ChannelBloc>().add(GetChannelsEvent(
        workspaceId: widget.workspace.id, categoryId: widget.category.id));
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: widget.category.name,
      onLongPress: () {
        showModalBottomSheet(
          context: context, 
          builder: (context) => CategoryOptions(widget: widget));
      },
      children: [
        BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            if (state.isLoading == true) {
              return ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(bottom: 8.0, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ));
            } else if (state.isSuccess == false && state.isLoading == false) {
              return Center(child: Text("Error: ${state.message}"));
            }
            final channels =
                Map<int, List<Channel>>.from(state.channelsByCategory);
            if (channels[widget.category.id] == null) {
              return const Center(child: Text("No Channels Available"));
            }
            return Column(
              children: channels[widget.category.id]!
                  .map((channel) => _buildSubcategory(
                      widget.workspace, widget.category, channel))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubcategory(
    Workspace workspace,
    Category category,
    Channel channel,
  ) {
    return CustomExpansionTile(
      title: channel.name,
      children: [
        _buildSubSubcategoryOption(
          "Assignment",
          workspace,
          category,
          channel,
          ChannelType.assignment,
        ),
        _buildSubSubcategoryOption(
          "Doubts",
          workspace,
          category,
          channel,
          ChannelType.doubts,
        ),
      ],
    );
  }

  Widget _buildSubSubcategoryOption(
    String option,
    Workspace workspace,
    Category category,
    Channel channel,
    ChannelType type,
  ) {
    if(ChannelType.assignment == type) {
      return AssignmentScreen(
        workspace: workspace, 
        category: category, 
        channel: channel);
    } else {
      return DoubtScreen(workspace: workspace, category: category, channel: channel);
    }
  }
}
enum ChannelType { assignment, doubts }
