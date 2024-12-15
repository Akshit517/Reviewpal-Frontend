import 'package:ReviewPal/features/auth/data/datasources/user_local_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/internet/network_info.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../../domain/repositories/workspace_repositories.dart';
import '../../datasources/workspace/workspace_remote_data_source.dart';

class WorkspaceRepositoriesImpl implements WorkspaceRepositories {
  final WorkspaceRemoteDataSource workspaceRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;

  WorkspaceRepositoriesImpl({
    required this.workspaceRemoteDataSource,
    required this.userLocalDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _checkNetwork<T>(
      Future<Either<Failure, T>> Function() action) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    return await action();
  }

  @override
  Future<Either<Failure, Workspace>> createWorkspace(
      String name, String icon) async {
    return await _checkNetwork(() async {
      try {
        final workspace =
            await workspaceRemoteDataSource.createWorkspace(name: name, icon: icon);
        return Right(workspace);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, void>> leaveWorkspace(
      String workspaceId) async {
    return await _checkNetwork(() async {
      try {
        final user = await userLocalDataSource.getCachedUser();
        final userEmail = user.email;
        await workspaceRemoteDataSource.removeWorkspaceMember(
            workspaceId: workspaceId, userEmail: userEmail);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace(
      String workspaceId, String name, String icon) async {
    return await _checkNetwork(() async {
      try {
        final updatedWorkspace = await workspaceRemoteDataSource.updateWorkspace(
          workspaceId: workspaceId,
          name: name,
          icon: icon,
        );
        return Right(updatedWorkspace);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId) async {
    return await _checkNetwork(() async {
      try {
        await workspaceRemoteDataSource.deleteWorkspace(workspaceId);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(
      String workspaceId) async {
    return await _checkNetwork(() async {
      try {
        final workspace = await workspaceRemoteDataSource.getWorkspace(
          workspaceId: workspaceId,
        );
        return Right(workspace);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces(
      String userId) async {
    return await _checkNetwork(() async {
      try {
        final workspaces = await workspaceRemoteDataSource.fetchWorkspaces();
        return Right(workspaces);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Workspace>> joinWorkspace(
      String workspaceId) async {
    return await _checkNetwork(() async {
      try {
        final user = await userLocalDataSource.getCachedUser();
        final userEmail = user.email;
        await workspaceRemoteDataSource.addWorkspaceMember(
              workspaceId: workspaceId, 
              userEmail: userEmail, 
              role: 'member'
            );
        final workspace = await workspaceRemoteDataSource.getWorkspace(
          workspaceId: workspaceId,
        );
        return Right(workspace);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>> > getMembers(
      String workspaceId) async {
    return await _checkNetwork(() async {
      try {
        final members =
            await workspaceRemoteDataSource.fetchWorkspaceMembers(workspaceId);
        return Right(members);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, void>> addMember(
      String workspaceId, String userEmail, String role) async {
    return await _checkNetwork(() async {
      try {
        await workspaceRemoteDataSource.addWorkspaceMember(
            workspaceId: workspaceId, userEmail: userEmail, role: role);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, void>> removeMember(
      String workspaceId, String userEmail) async {
    return await _checkNetwork(() async {
      try {
        await workspaceRemoteDataSource.removeWorkspaceMember(
            workspaceId: workspaceId, userEmail: userEmail);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    });
  }
}
