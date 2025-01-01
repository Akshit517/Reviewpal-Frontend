import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/workspace_repositories.dart';

class DeleteCategory {
  final WorkspaceRepositories repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(String workspaceId, int categoryId) async {
    return await repository.deleteCategory(workspaceId, categoryId);
  }
}