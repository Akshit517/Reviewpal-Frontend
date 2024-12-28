part of 'iteration_bloc.dart';

sealed class IterationEvent extends Equatable {
  const IterationEvent();

  @override
  List<Object> get props => [];
}

class GetRevieweeIterationsEvent extends IterationEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int submissionId;
  const GetRevieweeIterationsEvent(
      {required this.workspaceId,
      required this.categoryId,
      required this.channelId,
      required this.submissionId});
}

class GetReviewerIterationsEvent extends IterationEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int submissionId;
  const GetReviewerIterationsEvent(
      {required this.workspaceId,
      required this.categoryId,
      required this.channelId,
      required this.submissionId});
}

class CreateReviewerIterationEvent extends IterationEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int submissionId;
  final String remarks;
  final AssignmentStatus? assignmentStatus;
  const CreateReviewerIterationEvent(
      {required this.workspaceId,
      required this.categoryId,
      required this.channelId,
      required this.submissionId,
      required this.remarks,
      this.assignmentStatus});
}
