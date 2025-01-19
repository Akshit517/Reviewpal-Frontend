import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/submissions/submission.dart';
import '../../../domain/usecases/submission/create_submission.dart';
import '../../../domain/usecases/submission/submission.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final GetSubmissionByTeamIdUseCase getSubmissionByTeamId;
  final GetSubmissionUseCase getSubmission;
  final CreateSubmissionUseCase createSubmission;

  SubmissionBloc(
      {required this.getSubmissionByTeamId,
      required this.getSubmission,
      required this.createSubmission})
      : super(SubmissionInitial()) {
    on<CreateSubmissionEvent>(_createSubmissionEvent);
    on<GetSubmissionEvent>(_getSubmissionEvent);
    on<GetSubmissionByTeamIdEvent>(_getSubmissionByUserIdEvent);
  }

  Future<void> _createSubmissionEvent(
      CreateSubmissionEvent event, Emitter<SubmissionState> emit) async {
    emit(SubmissionLoading());
    final result = await createSubmission(CreateSubmissionParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        content: event.content,
        file: event.file));

    result.fold(
      (failure) => emit(SubmissionError(message: failure.message)),
      (_) => emit(
          const SubmissionSuccess(message: "Submission created successfully")),
    );
  }

  Future<void> _getSubmissionEvent(
      GetSubmissionEvent event, Emitter<SubmissionState> emit) async {
    emit(SubmissionLoading());
    final result = await getSubmission(SubmissionParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId));
    result.fold(
      (failure) => emit(SubmissionError(message: failure.message)),
      (submission) => emit(SubmissionSuccess(submissions: submission)),
    );
  }

  Future<void> _getSubmissionByUserIdEvent(
      GetSubmissionByTeamIdEvent event, Emitter<SubmissionState> emit) async {
    emit(SubmissionLoading());
    final result = await getSubmissionByTeamId(SubmissionParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        teamId: event.teamId));
    result.fold(
      (failure) => emit(SubmissionError(message: failure.message)),
      (submissions) => emit(SubmissionSuccess(submissions: submissions)),
    );
  }
}
