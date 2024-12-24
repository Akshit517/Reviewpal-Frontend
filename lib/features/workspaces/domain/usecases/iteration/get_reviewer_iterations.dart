import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';

class GetRevieweeIterations implements UseCase<RevieweeIterationsResponse, GetReviewParams> {
  final WorkspaceRepositories repository;

  GetRevieweeIterations(this.repository);

  @override
  Future<Either<Failure, RevieweeIterationsResponse>> call(GetReviewParams params) async {
    return await repository.getRevieweeIterations(
      params.workspaceId,
      params.categoryId,
      params.channelId,
      params.submissionId,
    );
  }
}