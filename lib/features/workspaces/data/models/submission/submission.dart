import 'package:ReviewPal/features/auth/data/models/user_model.dart';

import '../../../domain/entities/submissions/submission.dart';
import '../iteration/review_iteration_model.dart';

class SubmissionModel extends Submission {
  SubmissionModel({
    required super.id,
    super.sender,
    super.content,
    super.file,
    required super.submittedAt,
    super.reviewIteration,
  });
factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'],
      sender: json['sender'] != null 
          ? UserModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      content: json['content'] as String?,
      file: json['file'] as String?,
      submittedAt: DateTime.parse(json['submitted_at']),
      reviewIteration: json['iterations'] != null
          ? (json['iterations'] as List<dynamic>)
              .map((iteration) => ReviewIterationModel.fromJson(iteration as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
