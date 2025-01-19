import 'package:ReviewPal/core/resources/pallete/dark_theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/presentation/widgets/pillbox/pillbox.dart';
import '../../../data/models/iteration/review_iteration_model.dart';
import '../../../domain/entities/assignment/assignment_status.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/channel/channel_member.dart';
import '../../../domain/entities/submissions/submission.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/channel/member/channel_member_bloc.dart';
import '../../blocs/iteration/iteration_bloc.dart';
import '../../blocs/submission/submission_bloc.dart';

class SubmissionsByUserPage extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const SubmissionsByUserPage(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel});

  @override
  State<SubmissionsByUserPage> createState() => _SubmissionsByUserPageState();
}

class _SubmissionsByUserPageState extends State<SubmissionsByUserPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ChannelMemberBloc>().add(GetChannelMembersEvent(
            workspaceId: widget.workspace.id,
            categoryId: widget.category.id,
            channelId: widget.channel.id));
      }
    });
  }

  Widget _buildPageContent() {
    return BlocBuilder<ChannelMemberBloc, ChannelMemberState>(
      builder: (context, state) {
        if (state is ChannelMemberLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChannelMemberError) {
          return Center(child: Text(state.message));
        }

        if (state is ChannelMemberSuccess) {
          // Extract teams without reviewers
          final nonReviewerTeams = state.membersByTeam?.entries
                  .where((entry) =>
                      entry.value.every((member) => member.role != 'reviewer'))
                  .map((entry) => entry.key)
                  .where((team) => team != null)
                  .toList() ??
              [];

          if (nonReviewerTeams.isEmpty) {
            return const Center(
                child: Text("No teams without reviewers found"));
          }

          return ListView.builder(
            itemCount: nonReviewerTeams.length,
            itemBuilder: (context, index) {
              final team = nonReviewerTeams[index];
              final channelMember = state.membersByTeam?[team];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(team!.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  tileColor: DarkThemePalette.fillColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  subtitle: Text("${channelMember!.length} members"),
                  trailing: IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.person_2_rounded,
                        color: Colors.white,
                      )),
                  onTap: () => _showUserSubmissions(channelMember[0]),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showUserSubmissions(ChannelMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSubmissionsScreen(
          workspace: widget.workspace,
          category: widget.category,
          channel: widget.channel,
          teamId: member.team!.id,
          userName: member.user.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submissions By User",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, thickness: 3.0, color: Colors.grey),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 640;
          final contentWidth =
              isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isTablet) const Spacer(flex: 1),
              Container(
                width: contentWidth,
                padding: const EdgeInsets.all(15.0),
                child: _buildPageContent(),
              ),
              if (isTablet) const Spacer(flex: 1),
            ],
          );
        },
      ),
    );
  }
}

class UserSubmissionsScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  final String teamId;
  final String userName;

  const UserSubmissionsScreen({
    super.key,
    required this.workspace,
    required this.category,
    required this.channel,
    required this.teamId,
    required this.userName,
  });

  @override
  State<UserSubmissionsScreen> createState() => _UserSubmissionsScreenState();
}

class _UserSubmissionsScreenState extends State<UserSubmissionsScreen> {
  Map<int, List<ReviewIterationModel>> submissionIterations = {};

  @override
  void initState() {
    super.initState();
    _fetchSubmissions();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, y \'at\' h:mm a').format(dateTime.toLocal());
  }

  void _launchUrl(String uri) async {
    Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _fetchSubmissions() {
    context.read<SubmissionBloc>().add(GetSubmissionByTeamIdEvent(
        widget.workspace.id,
        widget.category.id,
        widget.channel.id,
        widget.teamId));
  }

  Future<void> _showCreateIterationDialog(
      int submissionId, int totalPoints) async {
    final TextEditingController remarksController = TextEditingController();
    String selectedStatus = 'ongoing';
    int earnedPoints = 0;
    String? pointsError;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Iteration'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: remarksController,
                    decoration: const InputDecoration(labelText: 'Remarks'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['ongoing', 'completed', 'incomplete']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedStatus = value!);
                    },
                  ),
                  if (selectedStatus == 'completed')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Earned Points',
                          errorText: pointsError,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final points = int.tryParse(value) ?? 0;
                          setState(() {
                            earnedPoints = points;
                            pointsError = (points > totalPoints)
                                ? 'Points must not exceed $totalPoints'
                                : null;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedStatus == 'completed' &&
                      earnedPoints > totalPoints) {
                    setState(() {
                      pointsError = 'Points must not exceed $totalPoints';
                    });
                    return;
                  }
                  context.read<IterationBloc>().add(
                        CreateReviewerIterationEvent(
                          workspaceId: widget.workspace.id,
                          categoryId: widget.category.id,
                          channelId: widget.channel.id,
                          submissionId: submissionId,
                          remarks: remarksController.text,
                          assignmentStatus: AssignmentStatus(
                            status: selectedStatus,
                            earnedPoints: selectedStatus == 'completed'
                                ? earnedPoints
                                : 0,
                          ),
                        ),
                      );
                  Navigator.pop(context);
                  _fetchSubmissions();
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmissionCard(
    Submission submission,
    List<ReviewIterationModel> iterations,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              submission.content ?? "No content",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Row(
              children: [
                Flexible(
                  child: Tooltip(
                    message: formatDateTime(submission.submittedAt),
                    child: Text(
                      formatDateTime(submission.submittedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                PillBox(
                  text: submission.sender?.username ?? "Unknown",
                  width: 160,
                  backgroundColor: DarkThemePalette.primaryDark,
                  textColor: DarkThemePalette.primaryAccent,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (submission.file != null)
                  IconButton(
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                      color: DarkThemePalette.primaryAccent,
                    ),
                    onPressed: () {
                      _launchUrl(submission.file!);
                    },
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.create_rounded,
                    color: DarkThemePalette.primaryAccent,
                  ),
                  onPressed: () => _showCreateIterationDialog(
                      submission.id, widget.channel.assignment!.totalPoints),
                ),
              ],
            ),
            tileColor: DarkThemePalette.fillColor,
          ),
          if (iterations.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                'Reviews:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: iterations.length,
              itemBuilder: (context, index) {
                final iteration = iterations[index];
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                  title: Text('Review by ${iteration.reviewer.username}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(iteration.remarks),
                      if (iteration.assignmentStatus != null) ...[
                        Text(
                          'Status: ${iteration.assignmentStatus!.status.toUpperCase()}',
                          style: TextStyle(
                            color:
                                iteration.assignmentStatus!.status == 'complete'
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                        ),
                        Text(
                          'Points: ${iteration.assignmentStatus!.earnedPoints}',
                        ),
                      ],
                      Text(
                        'Created: ${DateFormat('MMM d, y HH:mm').format(iteration.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Team's Submissions",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: BlocBuilder<SubmissionBloc, SubmissionState>(
        builder: (context, state) {
          if (state is SubmissionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubmissionError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is SubmissionSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.submissions!.length,
              itemBuilder: (context, index) {
                final submission = state.submissions![index];
                final iterations = submissionIterations[submission.id] ?? [];
                return _buildSubmissionCard(submission, iterations);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
