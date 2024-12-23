import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../blocs/workspace/workspace_bloc.dart';
import '../../blocs/category/category_bloc.dart';

class HomeScreenMain extends StatelessWidget {
  static const double _desktopBreakpoint = 1200;
  static const double _sidebarWidth = 300.0;
  
  const HomeScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
        
        return Row(
          children: [
            SizedBox(
              width: isDesktop ? _sidebarWidth : constraints.maxWidth,
              child: _CategoriesSidebar(
                isDesktop: isDesktop,
                onCategorySelected: isDesktop ? null : null
              ),
            ),
            
            // Content area for desktop
            if (isDesktop)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: DarkThemePalette.fillColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: const _ContentView(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoriesSidebar extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback? onCategorySelected;

  const _CategoriesSidebar({
    required this.isDesktop,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, workspaceState) {
        if (workspaceState is WorkspaceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (workspaceState is WorkspaceLoaded) {
          return Column(
            children: [
              // Workspace header
              _WorkspaceHeader(
                name: workspaceState.workspace.name,
                isDesktop: isDesktop,
              ),
              const Divider(
                thickness: 4,
                color: DarkThemePalette.fillColor,
              ),
              // Categories list
              Expanded(
                child: _CategoriesList(
                  onCategorySelected: onCategorySelected,
                ),
              ),
            ],
          );
        } else if (workspaceState is WorkspaceError) {
          return _buildErrorView(context, workspaceState.message);
        } else {
          return _buildNoWorkspaceView();
        }
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return RefreshIndicator(
      backgroundColor: DarkThemePalette.fillColor,
      color: Colors.grey,
      onRefresh: () async {
        context.read<WorkspaceBloc>().add(const GetJoinedWorkspacesEvent());
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 200),
          Center(child: Text("Error: $message")),
        ],
      ),
    );
  }

  Widget _buildNoWorkspaceView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("≧◉◡◉≦", style: TextStyle(fontSize: 40)),
        SizedBox(height: 4),
        Text("No Workspace Selected!!!"),
      ],
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  final String name;
  final bool isDesktop;

  const _WorkspaceHeader({
    required this.name,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/settings.svg"),
          ),
        ],
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final VoidCallback? onCategorySelected;

  const _CategoriesList({this.onCategorySelected});

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
                      category.name,
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
    String category,
    VoidCallback? onCategorySelected,
  ) {
    return CustomExpansionTile(
      title: category,
      onSubcategorySelected: onCategorySelected,
      children: [
        _buildSubcategory("Linux", onCategorySelected),
        _buildSubcategory("Git", onCategorySelected),
        _buildSubcategory("OOPS", onCategorySelected),
      ],
    );
  }

  Widget _buildSubcategory(String subcategory, VoidCallback? onCategorySelected) {
    return CustomExpansionTile(
      title: subcategory,
      onSubcategorySelected: onCategorySelected,
      children: [
        _buildSubSubcategoryOption("Assignment", onCategorySelected),
        _buildSubSubcategoryOption("Doubts", onCategorySelected),
      ],
    );
  }

  Widget _buildSubSubcategoryOption(
    String option,
    VoidCallback? onCategorySelected,
  ) {
    return InkWell(
      onTap: onCategorySelected,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset('assets/icons/hash.svg'),
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

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onSubcategorySelected;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.onSubcategorySelected,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        children: [
          if (_isExpanded)
            const Positioned(
              left: 7.5,
              top: 16,
              bottom: 8,
              child: VerticalDivider(
                thickness: 3,
                color: DarkThemePalette.fillColor,
                indent: 24,
                endIndent: 8,
              ),
            ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() => _isExpanded = !_isExpanded);
                  if (!_isExpanded) {
                    widget.onSubcategorySelected?.call();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(children: widget.children),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a channel to start chatting',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}