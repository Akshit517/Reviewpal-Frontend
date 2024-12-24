import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/assignment_status.dart';
import '../../entities/review_iteration.dart';
import '../../repositories/workspace_repositories.dart';

class CreateReviewIteration implements UseCase<ReviewIteration, CreateReviewParams> {
  final WorkspaceRepositories repository;

  CreateReviewIteration(this.repository);

  @override
  Future<Either<Failure, ReviewIteration>> call(CreateReviewParams params) async {
    return await repository.createIteration(
      params.workspaceId,
      params.categoryId,
      params.channelId,
      params.submissionId,
      params.remarks,
      params.assignmentStatus,
    );
  }
}

class CreateReviewParams {
  final String workspaceId;
  final String categoryId;
  final String channelId;
  final String submissionId;
  final String remarks;
  final AssignmentStatus? assignmentStatus;

  CreateReviewParams({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    required this.submissionId,
    required this.remarks,
    this.assignmentStatus,
  });
}