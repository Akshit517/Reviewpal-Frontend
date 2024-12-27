import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/submission.dart';
import '../../repositories/workspace_repositories.dart';

class GetSubmissionByUserIdUseCase implements UseCase<List<Submission>, SubmissionParams> {
  final WorkspaceRepositories repository;

  GetSubmissionByUserIdUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Submission>>> call(SubmissionParams params) async {
    return await repository.getSubmissionByUserId(params.workspaceId, params.categoryId, params.channelId, params.userId!);
  }
}

class GetSubmissionUseCase implements UseCase<List<Submission>, SubmissionParams> {
  final WorkspaceRepositories repository;

  GetSubmissionUseCase({required this.repository});
   
  @override
  Future<Either<Failure, List<Submission>>> call(SubmissionParams params) async {
    return await repository.getSubmissionReviewees(params.workspaceId, params.categoryId, params.channelId);
  }
}

class SubmissionParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int? userId;

  SubmissionParams({required this.workspaceId, required this.categoryId, required this.channelId, this.userId});
}