import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/workspace_entity.dart';

abstract class WorkspaceRepositories {
  Either<Failure, Workspace> createWorkspace(String name, String icon);

  Either<Failure, void> deleteWorkspace(String worksapceId);

  Either<Failure, Workspace> updateWorkspace(
      String worksapceId, String name, String icon);

  Either<Failure, void> leaveWorkspace(String worksapceId, String accessToken);

  Either<Failure, Workspace> joinWorkspace(String worksapceId, String accessToken);

  Either<Failure, List<Workspace>> getJoinedWorkspaces(
      String accessToken, String userId);

  Either<Failure, Workspace> getWorkspace(
      String worksapceId, String accessToken);

  Either<Failure, void> addMember(
      String worksapceId, String userEmail, String accessToken);

  Either<Failure, void> removeMember(
      String worksapceId, String userEmail, String accessToken);

  Either<Failure, Map<User, String>> getMembers(
      String worksapceId, String accessToken);
}

