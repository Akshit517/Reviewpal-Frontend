import 'package:equatable/equatable.dart';

import '../assignment/assignment_status.dart';
import 'review_iteration.dart';

class RevieweeIterationsResponse extends Equatable {
  final List<ReviewIteration> iterations;
  final int totalIterations;
  final AssignmentStatus? currentStatus;

  const RevieweeIterationsResponse({
    required this.iterations,
    required this.totalIterations,
    this.currentStatus,
  });

  @override
  List<Object?> get props => [iterations, totalIterations, currentStatus];
}