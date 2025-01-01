import '../../../domain/entities/assignment/assignment_status.dart';
import '../../../domain/entities/iteration/review_iteration_response.dart';
import 'review_iteration_model.dart';

class RevieweeIterationsResponseModel extends RevieweeIterationsResponse {
  const RevieweeIterationsResponseModel({
    required List<ReviewIterationModel> super.iterations,
    required super.totalIterations,
    super.currentStatus,
  });

  // From JSON
  factory RevieweeIterationsResponseModel.fromJson(Map<String, dynamic> json) {
    return RevieweeIterationsResponseModel(
      iterations: (json['iterations'] as List)
          .map((iterationJson) => ReviewIterationModel.fromJson(iterationJson))
          .toList(),
      totalIterations: json['total_iterations'],
      currentStatus: json['current_status'] != null
          ? AssignmentStatus(
              status: json['current_status']['status'],
              earnedPoints: json['current_status']['earned_points'],
            )
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'iterations': iterations
          .map((iteration) => (iteration as ReviewIterationModel).toJson())
          .toList(),
      'total_iterations': totalIterations,
      'current_status': currentStatus != null
          ? {
              'status': currentStatus!.status,
              'earned_points': currentStatus!.earnedPoints,
            }
          : null,
    };
  }
}