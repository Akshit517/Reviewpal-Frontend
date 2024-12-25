import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/workspace_member.dart';
import '../../repositories/workspace_repositories.dart';

class GetWorkspaceMembersUseCase implements UseCase<List<WorkspaceMember>, String> {
  final WorkspaceRepositories repository;

  GetWorkspaceMembersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<WorkspaceMember>>> call(String workspaceId) async {
    return await repository.getWorkspaceMembers(workspaceId);
  }
}

class GetWorkspaceMemberUseCase implements UseCase<WorkspaceMember, WorkspaceMemberParams> {
  final WorkspaceRepositories repository;

  GetWorkspaceMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, WorkspaceMember>> call(WorkspaceMemberParams params) async {
    return await repository.getWorkspaceMember(params.workspaceId, params.userEmail);
  }
}

class AddWorkspaceMemberUseCase implements UseCase<void, WorkspaceMemberParams> {
  final WorkspaceRepositories repository;

  AddWorkspaceMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(WorkspaceMemberParams params) async {
    return await repository.addWorkspaceMember(
      params.workspaceId,
      params.userEmail,
      params.role!,
    );
  }
}

class DeleteWorkspaceMemberUseCase implements UseCase<void, WorkspaceMemberParams> {
  final WorkspaceRepositories repository;

  DeleteWorkspaceMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(WorkspaceMemberParams params) async {
    return await repository.removeWorkspaceMember(
      params.workspaceId,
      params.userEmail,
    );
  }
}

class UpdateWorkspaceMemberUseCase implements UseCase<void, WorkspaceMemberParams> {
  final WorkspaceRepositories repository;

  UpdateWorkspaceMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(WorkspaceMemberParams params) async {
    return await repository.updateWorkspaceMember(params.workspaceId, params.userEmail, params.role!);
  }
}

class WorkspaceMemberParams {
  final String workspaceId;
  final String userEmail;
  final String? role;

  WorkspaceMemberParams({required this.workspaceId, required this.userEmail, this.role});
}