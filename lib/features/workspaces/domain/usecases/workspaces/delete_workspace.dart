import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/workspace_repositories.dart';

class DeleteWorkspace {
  final WorkspaceRepositories repository;

  DeleteWorkspace(this.repository);

  Future<Either<Failure, void>> call(String workspaceId) async {
    return await repository.deleteWorkspace(workspaceId);
  }
}
