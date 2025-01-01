import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/category/category_entity.dart';
import '../../repositories/workspace_repositories.dart';

class CreateCategory {
  final WorkspaceRepositories repository;

  CreateCategory(this.repository);

  Future<Either<Failure, Category>> call(String workspaceId, String name) async {
    return await repository.createCategory(workspaceId, name);
  }
}