
import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/workspace_entity.dart';

class UpdateWorkspace {
  final WorkspaceRepositories repository;

  UpdateWorkspace(this.repository);

  Future<Either<Failure, Workspace>> call(
      String workspaceId, String name, String icon) async {
    return await repository.updateWorkspace(workspaceId, name, icon);
  }
}