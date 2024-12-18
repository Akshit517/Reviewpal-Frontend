import 'package:ReviewPal/features/auth/data/models/user_model.dart';
import 'package:ReviewPal/features/workspaces/data/models/assignment/assignment.dart';

import '../../../domain/entities/submission.dart';

class SubmissionModel extends Submission {
  SubmissionModel({
    required String id,
    required AssignmentModel assignment,
    required UserModel sender,
    String? content,
    String? file,
    required DateTime submittedAt,
  }) : super(
          id: id,
          assignment: assignment.toEntity(),
          sender: sender,
          content: content,
          file: file,
          submittedAt: submittedAt,
        );

  // From JSON
  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'],
      assignment: AssignmentModel.fromJson(json['assignment']),
      sender: UserModel.fromJson(json['sender']), // Use UserModel here
      content: json['content'],
      file: json['file'],
      submittedAt: DateTime.parse(json['submitted_at']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment': assignment,
      'sender': sender, // Use sender.toJson() here
      'content': content,
      'file': file,
      'submitted_at': submittedAt.toIso8601String(),
    };
  }
}
