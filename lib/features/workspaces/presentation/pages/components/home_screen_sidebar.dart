import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../../core/widgets/buttons/inkwell_button.dart';
import '../../../../../core/widgets/effects/shimmer_loading_effect.dart';
import '../../../../../core/widgets/image/universal_image.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/workspace/workspace_bloc.dart';
import 'add_workspace_dialog.dart';
import 'workspace_options.dart';

class HomeScreenSidebar extends StatelessWidget {
  final bool isMobile;
  static const double _mobileRadius = 25;
  static const double _desktopRadius = 35;
  static const int _shimmerCount = 3;

  const HomeScreenSidebar({super.key, required this.isMobile});

  double get _avatarRadius => isMobile ? _mobileRadius : _desktopRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: _buildWorkspaceList()),
          _buildAddWorkspaceButton(context),
        ],
      ),
    );
  }

  Widget _buildWorkspaceList() {
    return BlocConsumer<WorkspaceBloc, WorkspaceState>(
      listenWhen: (previous, current) => 
          current is WorkspaceCreated || 
          current is WorkspaceError || 
          current is WorkspaceDeleted,
      listener: _handleWorkspaceStateChanges,
      buildWhen: (previous, current) =>
          current is WorkspacesLoaded || current is WorkspacesLoading || current is WorkspaceError,
      builder: (context, state) {
        if (state is WorkspacesLoaded) {
          return _buildLoadedWorkspaces(context, state.workspaces);
        }
        return _buildLoadingShimmer();
      },
    );
  }

  void _handleWorkspaceStateChanges(BuildContext context, WorkspaceState state) {
    final message = switch (state) {
      WorkspaceError() => state.message,
      WorkspaceDeleted() => "Workspace deleted successfully!!!",
      WorkspaceCreated() => "Workspace created successfully!!!",
      _ => null
    };

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildLoadedWorkspaces(BuildContext context, List<Workspace> workspaces) {
    return ListView.builder(
      itemCount: workspaces.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: _WorkspaceAvatar(
          workspace: workspaces[index],
          radius: _avatarRadius,
          onTap: () => _handleWorkspaceTap(context, workspaces[index]),
          onLongPress: () => _showWorkspaceOptions(context, workspaces[index]),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: _shimmerCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: ShimmerLoading(
          isLoading: true,
          child: CircleAvatar(radius: _avatarRadius),
        ),
      ),
    );
  }

  Widget _buildAddWorkspaceButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWellButton.circular(
        onTap: () => _showAddWorkspaceDialog(context),
        backgroundColor: DarkThemePalette.secondaryDarkGray,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _handleWorkspaceTap(BuildContext context, Workspace workspace) {
    context.read<CategoryBloc>().add(GetCategoriesEvent(workspaceId: workspace.id));
    context.read<WorkspaceBloc>().add(GetWorkspaceEvent(workspaceId: workspace.id));
  }

  void _showAddWorkspaceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddWorkspaceDialog(),
    );
  }

  Future<void> _showWorkspaceOptions(BuildContext context, Workspace workspace) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => WorkspaceOptions(workspace: workspace),
    );
  }
}

class _WorkspaceAvatar extends StatelessWidget {
  final Workspace workspace;
  final double radius;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _WorkspaceAvatar({
    required this.workspace,
    required this.radius,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ClipOval(
          child: UniversalImage(
            imageUrl: workspace.icon,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
