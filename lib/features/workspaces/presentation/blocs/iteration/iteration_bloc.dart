import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/assignment/assignment_status.dart';
import '../../../domain/entities/iteration/review_iteration.dart';
import '../../../domain/entities/iteration/review_iteration_response.dart';
import '../../../domain/usecases/iteration/create_review_iteration.dart';
import '../../../domain/usecases/iteration/get_reviewee_iteration.dart';
import '../../../domain/usecases/iteration/get_reviewer_iteration.dart';

part 'iteration_event.dart';
part 'iteration_state.dart';

class IterationBloc extends Bloc<IterationEvent, IterationState> {
  final GetRevieweeIterations getRevieweeIterations;
  final GetReviewerIteration getReviewerIterations;
  final CreateReviewIteration createReviewerIteration;

  final Map<int, RevieweeIterationsResponse> _submissionIterations = {};

  IterationBloc({
    required this.getRevieweeIterations,
    required this.getReviewerIterations,
    required this.createReviewerIteration,
  }) : super(IterationInitial()) {
    on<GetRevieweeIterationsEvent>(_onGetRevieweeIterations);
    on<GetReviewerIterationsEvent>(_onGetReviewerIterations);
    on<CreateReviewerIterationEvent>(_onCreateReviewerIteration);
  }

  Future<void> _onGetRevieweeIterations(
    GetRevieweeIterationsEvent event,
    Emitter<IterationState> emit,
  ) async {
    final result = await getRevieweeIterations(
      GetReviewParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        submissionId: event.submissionId,
      ),
    );
    result.fold(
      (failure) => emit(IterationError(message: failure.message)),
      (revieweeIterations) {
        _submissionIterations[event.submissionId] = revieweeIterations;
        emit(IterationSuccess(submissionIterations: _submissionIterations));
      }
    );
  }

  Future<void> _onGetReviewerIterations(
    GetReviewerIterationsEvent event,
    Emitter<IterationState> emit,
  ) async {
    final result = await getReviewerIterations(
      GetReviewParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        submissionId: event.submissionId,
      ),
    );
    result.fold(
      (failure) => emit(IterationError(message: failure.message)),
      (reviewerIterations) => emit(
        IterationSuccess(iterations: reviewerIterations),
      ),
    );
  }

  Future<void> _onCreateReviewerIteration(
    CreateReviewerIterationEvent event,
    Emitter<IterationState> emit,
  ) async {
    final result = await createReviewerIteration(
      CreateReviewParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        submissionId: event.submissionId,
        remarks: event.remarks,
        assignmentStatus: event.assignmentStatus,
      ),
    );
    result.fold(
      (failure) => emit(IterationError(message: failure.message)),
      (reviewerIteration) => emit(
        IterationSuccess(iterations: reviewerIteration),
      ),
    );
  }
}


