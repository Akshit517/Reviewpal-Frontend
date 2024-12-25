import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../repositories/workspace_repositories.dart';

class CreateSubmissionUseCase implements UseCase<void, CreateSubmissionParams> {
  final WorkspaceRepositories repository;

  CreateSubmissionUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateSubmissionParams params) async {
    return await repository.createSubmissionReviewee(
      params.workspaceId, 
      params.categoryId,
      params.channelId, 
      params.content, 
      params.file
    );
}
}

class CreateSubmissionParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String? content;
  final String? file;

  CreateSubmissionParams({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    this.content,
    this.file,
  });
}