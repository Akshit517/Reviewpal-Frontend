import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/workspace/workspace_entity.dart';
import '../../repositories/workspace_repositories.dart';

class GetWorkspace {
  final WorkspaceRepositories repository;

  GetWorkspace(this.repository);

  Future<Either<Failure, Workspace>> call(String workspaceId) async {
    return await repository.getWorkspace(workspaceId);
  }
}