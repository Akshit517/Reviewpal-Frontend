part of 'submission_bloc.dart';

sealed class SubmissionEvent extends Equatable {
  const SubmissionEvent();

  @override
  List<Object> get props => [];
}

class CreateSubmissionEvent extends SubmissionEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String? content;
  final String? file;

  const CreateSubmissionEvent(
      {required this.workspaceId,
      required this.categoryId,
      required this.channelId,
      this.content,
      this.file});
}

class GetSubmissionEvent extends SubmissionEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const GetSubmissionEvent(this.workspaceId, this.categoryId, this.channelId);
}

class GetSubmissionByTeamIdEvent extends SubmissionEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String teamId;

  const GetSubmissionByTeamIdEvent(
      this.workspaceId, this.categoryId, this.channelId, this.teamId);
}
