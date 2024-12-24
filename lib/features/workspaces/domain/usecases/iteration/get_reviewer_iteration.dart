import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/review_iteration.dart';

class GetReviewerIteration {
  final WorkspaceRepositories repository;

  GetReviewerIteration(this.repository);

  @override
  Future<Either<Failure, ReviewIteration>> call(String workspaceId, String categoryId, String channelId, String submissionId) async {
    return await repository.getReviewerIteration(
      workspaceId,
      categoryId,
      channelId,
      submissionId,
    );
  }
}