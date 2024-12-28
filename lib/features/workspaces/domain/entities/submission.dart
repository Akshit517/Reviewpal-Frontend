
import 'package:ReviewPal/features/workspaces/domain/entities/review_iteration.dart';

import '../../../auth/domain/entities/user_entity.dart';

class Submission {
  final int id;
  final User? sender;
  final String? content;
  final String? file; 
  final DateTime submittedAt;
  final List<ReviewIteration>? reviewIteration;

  Submission({
    required this.id,
    this.sender,
    this.content,
    this.file,
    required this.submittedAt,
    this.reviewIteration
  });
}