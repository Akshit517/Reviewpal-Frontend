
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/assignment_entity.dart';
import '../../repositories/workspace_repositories.dart';

class GetAssignmentUseCase implements UseCase<Assignment, AssignmentParams> {
  final WorkspaceRepositories repository;

  GetAssignmentUseCase({required this.repository});

  @override
  Future<Either<Failure, Assignment>> call(AssignmentParams params) async {
    return await repository.getAssignment(params.workspaceId, params.categoryId, params.channelId);
  }
}

class AssignmentParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  AssignmentParams(this.workspaceId, this.categoryId, this.channelId);
}