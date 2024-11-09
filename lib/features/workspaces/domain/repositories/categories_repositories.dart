import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';

abstract class CategoriesRepositories {

  Either<Failure, List<Category>> getCategories(String workspaceId, String accessToken);

  Either<Failure, Category> createCategory(String workspaceId, String name, String color, String accessToken);

  Either<Failure, void> deleteCategory(String workspaceId, String id, String accessToken);

  Either<Failure, Category> updateCategory(String workspaceId, String id,  String accessToken, String? name );

  Either<Failure, Category> getCategory(String workspaceId, String id, String accessToken);
  //list since user inside category have no roles
  Either<Failure, List<User>> getCategoryMembers(String workspaceId, String id, String accessToken);

  Either<Failure, void> addMemberToCategory(String workspaceId, String id, String email, String accessToken);

  Either<Failure, void> removeMemberFromCategory(String workspaceId, String id, String email, String accessToken);
}