import 'package:ReviewPal/features/workspaces/presentation/pages/components/channel_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/presentation/widgets/buttons/custom_expansion_tile.dart';
import '../../../../../core/presentation/widgets/effects/shimmer_loading_effect.dart';
import '../../../../injection.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/channel/channel_bloc/channel_bloc.dart';
import 'category_options.dart';

class CategoryExpansionTile extends StatefulWidget {
  final Workspace workspace;
  final Category category;

  const CategoryExpansionTile({
    super.key,
    required this.category,
    required this.workspace,
  });

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  late Future<dynamic> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = Utils.getUser(sl());
    context.read<ChannelBloc>().add(
          GetChannelsEvent(
            workspaceId: widget.workspace.id,
            categoryId: widget.category.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: widget.category.name,
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => CategoryOptions(widget: widget),
        );
      },
      children: [
        BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            if (state.isLoading == true && state.isSuccess == false) {
              return ShimmerLoading(
                isLoading: true,
                child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(bottom: 8.0, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            }

            if (state.isSuccess == false && state.isLoading == false) {
              return Center(child: Text("Error: ${state.message}"));
            }

            final channels = Map<int, List<Channel>>.from(state.channelsByCategory);
            final categoryChannels = channels[widget.category.id];

            if (categoryChannels == null || categoryChannels.isEmpty) {
              return const Center(child: Text("No Channels Available"));
            }

            return FutureBuilder<dynamic>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final user = snapshot.data;

                return Column(
                  children: categoryChannels
                      .map(
                        (channel) => ChannelExpansionTile(
                          workspace: widget.workspace,
                          category: widget.category,
                          channel: channel,
                          user: user,
                        ),
                      )
                      .toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
