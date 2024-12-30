import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/iteration/review_iteration_response.dart';
import '../../repositories/workspace_repositories.dart';

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

class GetReviewParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int submissionId;

  GetReviewParams({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    required this.submissionId, 
  });
}