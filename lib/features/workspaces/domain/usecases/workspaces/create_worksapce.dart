import 'package:ReviewPal/features/workspaces/domain/entities/workspace/workspace_entity.dart';
import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

class CreateWorkspace {
  final WorkspaceRepositories repository;

  CreateWorkspace(this.repository);

  Future<Either<Failure, Workspace>> call(String name, String icon) async {
    return await repository.createWorkspace(name, icon);
  }
}