part of 'iteration_bloc.dart';

sealed class IterationState extends Equatable {
  const IterationState();
  
  @override
  List<Object?> get props => [];
}

final class IterationInitial extends IterationState {}

final class IterationLoading extends IterationState {}

final class IterationSuccess extends IterationState {
  final ReviewIteration? iterations;
  final Map<int,RevieweeIterationsResponse>? submissionIterations;
  final String? message;
  const IterationSuccess({this.iterations, this.submissionIterations, this.message});
  @override
  List<Object?> get props => [iterations];
}

final class IterationError extends IterationState {
  final String? message;
  const IterationError({required this.message});
  @override
  List<Object?> get props => [message];
}