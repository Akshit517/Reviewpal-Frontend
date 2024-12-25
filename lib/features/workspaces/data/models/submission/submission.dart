import 'package:ReviewPal/features/auth/data/models/user_model.dart';
import 'package:ReviewPal/features/workspaces/data/models/assignment/assignment.dart';

import '../../../domain/entities/submission.dart';

class SubmissionModel extends Submission {
  SubmissionModel({
    required super.id,
    super.assignment,
    super.sender,
    super.content,
    super.file,
    required super.submittedAt,
  });
factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'],
      assignment: json['assignment'] != null 
          ? AssignmentModel.fromJson(json['assignment'] as Map<String, dynamic>)
          : null,
      sender: json['sender'] != null 
          ? UserModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      content: json['content'] as String?,
      file: json['file'] as String?,
      submittedAt: json['submitted_at']
    );
  }
}
