import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/category/category_bloc.dart';
import 'category_expansion_tile.dart';

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
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isLoading == false && state.isSuccess == true) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: state.categories
                .map((category) => CategoryExpansionTile(
                  category: category,
                  workspace: workspace,
                ))
                .toList(),
          );
        } else if (state.isLoading == false && state.isSuccess == false) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const Center(child: Text("No Categories Available"));
      },
    );
  }
}