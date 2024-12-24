import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';
import 'assignment_status.dart';

class ReviewIteration extends Equatable {
  final int id;
  final User reviewer;
  final User? reviewee;
  final String remarks;
  final DateTime createdAt;
  final AssignmentStatus? assignmentStatus;

  const ReviewIteration({
    required this.id,
    required this.reviewer,
    this.reviewee,
    required this.remarks,
    required this.createdAt,
    this.assignmentStatus,
  });

  @override
  List<Object?> get props => [
        id,
        reviewer,
        reviewee,
        remarks,
        createdAt,
        assignmentStatus,
      ];
}