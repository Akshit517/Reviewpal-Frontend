import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/workspace_entity.dart';

abstract class WorkspaceRepositories {
  Future<Either<Failure, Workspace>> createWorkspace(String name, String icon);

  Future<Either<Failure, void>> deleteWorkspace(String workspaceId);

  Future<Either<Failure, Workspace>> updateWorkspace(
      String workspaceId, String name, String icon);

  Future<Either<Failure, void>> leaveWorkspace(String workspaceId);

  Future<Either<Failure, Workspace>> joinWorkspace(String workspaceId);

  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces(
      String userId);

  Future<Either<Failure, Workspace>> getWorkspace(
      String workspaceId);

  Future<Either<Failure, void>> addMember(
      String workspaceId, String userEmail);

  Future<Either<Failure, void>> removeMember(
      String workspaceId, String userEmail);

  Future<Either<Failure, Map<User, String>>> getMembers(
      String workspaceId);
}
