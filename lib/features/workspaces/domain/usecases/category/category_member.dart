import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/category_member.dart';
import '../../repositories/workspace_repositories.dart';

class GetCategoryMembersUseCase implements UseCase<List<CategoryMember>, CategoryMemberParams> {
  final WorkspaceRepositories repository;

  GetCategoryMembersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryMember>>> call(CategoryMemberParams params) async {
    return await repository.getCategoryMembers(
      params.workspaceId, 
      params.categoryId
    );
  }
}

class GetCategoryMemberUseCase implements UseCase<CategoryMember, CategoryMemberParams> {
  final WorkspaceRepositories repository;

  GetCategoryMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, CategoryMember>> call(CategoryMemberParams params) async {
    return await repository.getCategoryMember(
      params.workspaceId, 
      params.categoryId, 
      params.email
    );
  }
} 

class UpdateCategoryMemberUseCase implements UseCase<void, CategoryMemberParams> {
  final WorkspaceRepositories repository;

  UpdateCategoryMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CategoryMemberParams params) async {
    return await repository.updateCategoryMember(
      params.workspaceId, 
      params.categoryId, 
      params.email, 
      params.role!
    );
  }
}

class AddCategoryMemberUseCase implements UseCase<void, CategoryMemberParams> {
  final WorkspaceRepositories repository;

  AddCategoryMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CategoryMemberParams params) async {
    return await repository.addMemberToCategory(
      params.workspaceId, 
      params.categoryId, 
      params.email, 
    );
  }
}

class DeleteCategoryMemberUseCase implements UseCase<void, CategoryMemberParams> {
  final WorkspaceRepositories repository;

  DeleteCategoryMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CategoryMemberParams params) async {
    return await repository.removeMemberFromCategory(
      params.workspaceId, 
      params.categoryId, 
      params.email, 
    );
  }
}


class CategoryMemberParams {
  final String workspaceId;
  final int categoryId;
  final String email;
  final String? role;

  CategoryMemberParams({required this.workspaceId, required this.categoryId, required this.email, this.role});
}