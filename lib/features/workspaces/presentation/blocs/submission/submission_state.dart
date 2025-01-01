part of 'submission_bloc.dart';

sealed class SubmissionState extends Equatable {
  const SubmissionState();
  
  @override
  List<Object?> get props => [];
}

final class SubmissionInitial extends SubmissionState {}

final class SubmissionLoading extends SubmissionState {}
final class SubmissionSuccess extends SubmissionState {
  final List<Submission>? submissions;
  final String? message;
  const SubmissionSuccess({this.submissions, this.message});
  @override
  List<Object?> get props => [submissions, message];
}

final class SubmissionError extends SubmissionState {
  final String? message;
  const SubmissionError({this.message});
  @override
  List<Object?> get props => [message];
}