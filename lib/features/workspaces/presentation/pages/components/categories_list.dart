import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/channel/bloc/channel_bloc.dart';
import 'custom_expansion_tile.dart';

class CategoriesList extends StatelessWidget {
  final Workspace workspace;
  final VoidCallback? onCategorySelected;

  const CategoriesList({
    super.key, 
    required this.workspace,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: state.categories
                .map((category) => _buildCategory(
                      context,
                      workspace,
                      category,
                      onCategorySelected,
                    ))
                .toList(),
          );
        } else if (state is CategoryError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const Center(child: Text("No Categories Available"));
      },
    );
  }

  Widget _buildCategory(
    BuildContext context,
    Workspace workspace,
    Category category,
    VoidCallback? onCategorySelected,
  ) {
    return CustomExpansionTile(
      title: category.name,
      children: [
        BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            if (state is ChannelLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChannelsLoaded) {
              return Column(
                children: state.channels
                    .map((channel) => _buildSubcategory(
                          workspace,
                          category,
                          channel,
                          onCategorySelected,
                        ))
                    .toList(),
              );
            } else if (state is ChannelError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("No Channels Available"));
          },
        ),
      ],
    );
  }

  Widget _buildSubcategory(
    Workspace workspace,
    Category category,
    Channel channel,
    VoidCallback? onCategorySelected,
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
          onCategorySelected,
        ),
        _buildSubSubcategoryOption(
          "Doubts",
          workspace,
          category,
          channel,
          ChannelType.doubts,
          onCategorySelected,
        ),
      ],
    );
  }

  Widget _buildSubSubcategoryOption(
    String option,
    Workspace workspace,
    Category category,
    Channel channelId,
    ChannelType type,
    VoidCallback? onCategorySelected,
  ) {
    return InkWell(
      onTap: () {
        onCategorySelected?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                type == ChannelType.assignment
                    ? Icons.assignment_outlined
                    : Icons.chat_bubble_outline,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ChannelType { 
  assignment,
  doubts
}