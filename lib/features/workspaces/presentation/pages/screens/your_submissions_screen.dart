import 'package:ReviewPal/core/resources/pallete/dark_theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/iteration/iteration_bloc.dart';
import '../../blocs/submission/submission_bloc.dart';

class YourSubmissionsScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const YourSubmissionsScreen({
    super.key,
    required this.workspace,
    required this.category,
    required this.channel,
  });

  @override
  _YourSubmissionsScreenState createState() => _YourSubmissionsScreenState();
}

class _YourSubmissionsScreenState extends State<YourSubmissionsScreen> {
  late SubmissionBloc _submissionBloc;
  late IterationBloc _iterationBloc;

  @override
  void initState() {
    super.initState();
    _submissionBloc = context.read<SubmissionBloc>();
    _iterationBloc = context.read<IterationBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submissionBloc.add(GetSubmissionEvent(
        widget.workspace.id,
        widget.category.id,
        widget.channel.id,
      ));
    });
  }

  void _showIterations(int submissionId) {
    _iterationBloc.add(GetRevieweeIterationsEvent(
      workspaceId: widget.workspace.id,
      categoryId: widget.category.id,
      channelId: widget.channel.id,
      submissionId: submissionId,
    ));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _IterationsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildSubmissionList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Your Submissions",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0, thickness: 3.0, color: Colors.grey),
      ),
    );
  }

  Widget _buildSubmissionList() {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SubmissionError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        if (state is SubmissionSuccess) {
          final submissions = state.submissions!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final submission = submissions[index];
              return Card(
                child: ListTile(
                  title: Text(
                    submission.content ?? "No content",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    submission.submittedAt.toLocal().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showIterations(submission.id),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No submissions found.'));
      },
    );
  }
}

class _IterationsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: DarkThemePalette.secondaryDarkGray,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: BlocBuilder<IterationBloc, IterationState>(
            builder: (context, state) {
              if (state is IterationLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is IterationError) {
                return Center(
                  child: Text(
                    "Error: ${state.message}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              if (state is IterationSuccess) {
                final iterations = state.revieweeIterations!.iterations;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Iterations (${state.revieweeIterations!.totalIterations})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: iterations.length,
                        itemBuilder: (context, index) {
                          final iteration = iterations[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                'Iteration ${index + 1}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                iteration.assignmentStatus!.status.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
