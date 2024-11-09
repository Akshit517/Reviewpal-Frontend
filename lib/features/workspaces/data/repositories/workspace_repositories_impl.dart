import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/repositories/workspace_repositories.dart';
import '../datasources/workspace/workspace_local_data_source.dart';
import '../datasources/workspace/workspace_remote_data_source.dart';

class WorkspaceRepositoriesImpl implements WorkspaceRepositories {
  final WorkspaceRemoteDataSource workspaceRemoteDataSource;
  final WorkspaceLocalDataSource workspaceLocalDataSource;
  final NetworkInfo networkInfo;

  WorkspaceRepositoriesImpl({
    required this.workspaceRemoteDataSource,
    required this.workspaceLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Workspace>> createWorkspace(String name, String icon) {
    // TODO: implement createWorkspace
    throw UnimplementedError();
  } 

  @override
  Future<Either<Failure, void>> leaveWorkspace(String worksapceId, String accessToken) {
    // TODO: implement leaveWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace(String worksapceId, String name, String icon) {
    // TODO: implement updateWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String worksapceId) {
    // TODO: implement deleteWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(String worksapceId, String accessToken) {
    // TODO: implement getWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces(String accessToken, String userId) {
    // TODO: implement getJoinedWorkspaces
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Workspace>> joinWorkspace(String worksapceId, String accessToken) {
    // TODO: implement joinWorkspace
    throw UnimplementedError();
  } 

  @override
  Future<Either<Failure, Map<User, String>>> getMembers(String worksapceId, String accessToken) {
    // TODO: implement getMembers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> addMember(String worksapceId, String userEmail, String accessToken) {
    // TODO: implement addMember
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeMember(String worksapceId, String userEmail, String accessToken) {
    // TODO: implement removeMember
    throw UnimplementedError();
  } 
}