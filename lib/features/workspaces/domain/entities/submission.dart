import '../../../auth/domain/entities/user_entity.dart';
import 'assignment_entity.dart';

class Submission {
  final String id;
  final Assignment assignment;
  final User sender;
  final String? content;
  final String? file; // URL or path to the file
  final DateTime submittedAt;

  Submission({
    required this.id,
    required this.assignment,
    required this.sender,
    this.content,
    this.file,
    required this.submittedAt,
  });
}