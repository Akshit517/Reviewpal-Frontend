import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/review_iteration.dart';
import '../../repositories/workspace_repositories.dart';
import 'get_reviewer_iterations.dart';

class GetReviewerIteration implements UseCase<ReviewIteration, GetReviewParams> {
  final WorkspaceRepositories repository;

  GetReviewerIteration(this.repository);

  @override
  Future<Either<Failure, ReviewIteration>> call(GetReviewParams params) async {
    return await repository.getReviewerIteration(
      params.workspaceId,
      params.categoryId,
      params.channelId,
      params.submissionId,
    );
  }
}