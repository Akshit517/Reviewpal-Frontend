import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../../core/resources/routes/routes.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/assignment/task_entity.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/channel/single_member/single_channel_member_cubit.dart';
import '../components/create_submission_dialog.dart';
import '../components/home_screen_main.dart';
import 'package:intl/intl.dart';

class AssignmentScreen extends StatelessWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const AssignmentScreen(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= HomeScreenMain.desktopBreakpoint;
    final roleState = context.watch<SingleChannelMemberCubit>().state;
    final key = '${workspace.id}-${category.id}-${channel.id}';
    final role = roleState.members[key]?.role;

    return Scaffold(
      appBar: _buildAppBar(category.name, channel.name, context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isDesktop),
                    const SizedBox(height: 24),
                    _buildDescription(context),
                    const SizedBox(height: 32),
                    _buildTasksList(isDesktop, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: DarkThemePalette.primaryDark,
        foregroundColor: DarkThemePalette.primaryAccent,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 5.0,
        spacing: 10.0,
        spaceBetweenChildren: 15.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        label: const Text(
          'Menu Options',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        children: role == 'reviewer'
            ? [
                SpeedDialChild(
                  child: const Icon(Icons.repeat),
                  label: 'Iterate',
                  labelStyle: const TextStyle(fontSize: 14.0),
                  backgroundColor: DarkThemePalette.primaryDark,
                  onTap: () => context.push(
                      CustomNavigationHelper.submissionsByUsersPath,
                      extra: {
                        "workspace": workspace,
                        "category": category,
                        "channel": channel
                      }),
                ),
              ]
            : [
                SpeedDialChild(
                  child: const Icon(Icons.add_rounded),
                  label: 'Create Submissions',
                  labelStyle: const TextStyle(fontSize: 14.0),
                  backgroundColor: DarkThemePalette.primaryDark,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => CreateSubmissionDialog(
                            workspace: workspace,
                            category: category,
                            channel: channel));
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.assignment_outlined),
                  label: 'Team Submissions',
                  labelStyle: const TextStyle(fontSize: 14.0),
                  backgroundColor: DarkThemePalette.primaryDark,
                  onTap: () {
                    context.push(CustomNavigationHelper.submissionsPath,
                        extra: {
                          "workspace": workspace,
                          "category": category,
                          "channel": channel
                        });
                  },
                ),
              ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DarkThemePalette.secondaryDarkGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: _buildChip(
                icon: Icons.star_outline,
                label: '${channel.assignment!.totalPoints} Points',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DarkThemePalette.secondaryDarkGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            channel.assignment!.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(bool isDesktop, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'Tasks',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 200,
          ),
          itemCount: channel.assignment!.tasks.length,
          itemBuilder: (context, index) {
            final task = channel.assignment!.tasks[index];
            return _buildTaskCard(task, context);
          },
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DarkThemePalette.secondaryDarkGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DarkThemePalette.primaryDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.task_alt,
                  color: DarkThemePalette.primaryAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              task.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(task.dueDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DarkThemePalette.primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: DarkThemePalette.primaryAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
      String categoryTitle, String channelTitle, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      title: Row(
        children: [
          Text(
            categoryTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
          Text(
            channelTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 3.0,
          color: Theme.of(context).dividerColor,
        ),
      ),
      leading: HomeScreenMain.desktopBreakpoint <= size.width
          ? null
          : IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
      elevation: 0,
    );
  }
}
