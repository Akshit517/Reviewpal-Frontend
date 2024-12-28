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
  final RevieweeIterationsResponse? revieweeIterations;
  final String? message;
  const IterationSuccess({this.iterations, this.revieweeIterations, this.message});
  @override
  List<Object?> get props => [iterations];
}

final class IterationError extends IterationState {
  final String? message;
  const IterationError({required this.message});
  @override
  List<Object?> get props => [message];
}