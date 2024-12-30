import 'package:ReviewPal/features/auth/data/models/user_model.dart';

import '../../../domain/entities/assignment/assignment_status.dart';
import '../../../domain/entities/iteration/review_iteration.dart';

class ReviewIterationModel extends ReviewIteration {
  const ReviewIterationModel({
    required super.id,
    required super.reviewer,
    super.reviewee,
    required super.remarks,
    required super.createdAt,
    super.assignmentStatus,
  });

  factory ReviewIterationModel.fromJson(Map<String, dynamic> json) {
    return ReviewIterationModel(
      id: json['id'],
      reviewer: UserModel.fromJson(json['reviewer']),
      reviewee: json['reviewee'] != null
          ? UserModel.fromJson(json['reviewee'])
          : null,
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']),
      assignmentStatus: json['assignment_status'] != null
          ? AssignmentStatus(
              status: json['assignment_status']['status'],
              earnedPoints: json['assignment_status']['earned_points'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remarks': remarks,
      'assignment_status': assignmentStatus != null
          ? {
              'status': assignmentStatus!.status,
              'earned_points': assignmentStatus!.earnedPoints,
            }
          : null,
    };
  }
}