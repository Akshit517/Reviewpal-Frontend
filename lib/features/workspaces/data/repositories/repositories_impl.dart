import 'package:ReviewPal/features/auth/data/datasources/user_local_data_source.dart';
import 'package:ReviewPal/features/workspaces/data/datasources/remote_data_source.dart';
import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/entities/workspace_member.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepositories {
  final WorkspaceRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource, required this.userLocalDataSource});

  Failure _handleException(Object e) {
    if (e is UnAuthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return const ServerFailure();
    } else {
      return const GeneralFailure();
    }
  }

  @override
  Future<Either<Failure, Workspace>> createWorkspace(String name, String icon) async {
    try {
      final workspaceModel = await remoteDataSource.createWorkspace(name: name, icon: icon);
      return Right(workspaceModel);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId) async {
    try {
      await remoteDataSource.deleteWorkspace(workspaceId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace(String workspaceId, String name, String icon) async {
    try {
      final updatedWorkspace = await remoteDataSource.updateWorkspace(
        workspaceId: workspaceId,
        name: name,
        icon: icon,
      );
      return Right(updatedWorkspace);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  //@override
  //Future<Either<Failure, void>> leaveWorkspace(String workspaceId) async {
  //  try {
  //     final user = await userLocalDataSource.getCachedUser();
  //     final email = user.email;
  //     await remoteDataSource.removeWorkspaceMember(
  //      workspaceId: workspaceId, 
  //      userEmail: email);
  //     return const Right(null);
  //  }
  //  catch (e) {
  //    return Left(_handleException(e));
  //  }
  //}

  // Commented as not implemented
  // @override
  // Future<Either<Failure, Workspace>> joinWorkspace(String workspaceId) {
  //   // TODO: Implement this method
  // }

  @override
  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces() async {
    try {
      final workspaces = await remoteDataSource.fetchWorkspaces();
      return Right(workspaces.map((e) => e).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(String workspaceId) async {
    try {
      final workspace = await remoteDataSource.getWorkspace(workspaceId: workspaceId);
      return Right(workspace);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addWorkspaceMember(String workspaceId, String userEmail, String role) async {
    try {
      await remoteDataSource.addWorkspaceMember(
        workspaceId: workspaceId,
        userEmail: userEmail,
        role: role,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeWorkspaceMember(String workspaceId, String userEmail) async {
    try {
      await remoteDataSource.removeWorkspaceMember(
        workspaceId: workspaceId,
        userEmail: userEmail,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<WorkspaceMember>>> getWorkspaceMembers(String workspaceId) async {
    try {
      final members = await remoteDataSource.fetchWorkspaceMembers(workspaceId);
      return Right(members);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // Commented as not implemented
  // @override
  // Future<Either<Failure, WorkspaceMember>> getWorkspaceMember(String workspaceId, String email) {
  //   // TODO: Implement this method
  // }

  // Commented as not implemented
  // @override
  // Future<Either<Failure, void>> updateWorkspaceMember(String workspaceId, String email, String role) {
  //   // TODO: Implement this method
  // }

  @override
  Future<Either<Failure, List<Category>>> getCategories(String workspaceId) async {
    try {
      final categories = await remoteDataSource.fetchCategories(workspaceId);
      return Right(categories.map((e) => e).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(String workspaceId, String name) async {
    try {
      final category = await remoteDataSource.createCategory(workspaceId, name);
      return Right(category);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String workspaceId, String id) async {
    try {
      await remoteDataSource.deleteCategory(workspaceId, id);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // Additional methods would follow a similar pattern.
}
