import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/submissions/submission.dart';
import '../../repositories/workspace_repositories.dart';

class GetSubmissionByTeamIdUseCase
    implements UseCase<List<Submission>, SubmissionParams> {
  final WorkspaceRepositories repository;

  GetSubmissionByTeamIdUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Submission>>> call(
      SubmissionParams params) async {
    return await repository.getSubmissionByTeamId(params.workspaceId,
        params.categoryId, params.channelId, params.teamId!);
  }
}

class GetSubmissionUseCase
    implements UseCase<List<Submission>, SubmissionParams> {
  final WorkspaceRepositories repository;

  GetSubmissionUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Submission>>> call(
      SubmissionParams params) async {
    return await repository.getSubmissionReviewees(
        params.workspaceId, params.categoryId, params.channelId);
  }
}

class SubmissionParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final int? userId;
  final String? teamId;

  SubmissionParams(
      {required this.workspaceId,
      required this.categoryId,
      required this.channelId,
      this.userId,
      this.teamId});
}
