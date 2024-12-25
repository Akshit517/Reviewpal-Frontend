part of 'workspace_member_bloc.dart';

sealed class WorkspaceMemberEvent extends Equatable {
  const WorkspaceMemberEvent();

  @override
  List<Object> get props => [];
}

class GetWorkspaceMembersEvent extends WorkspaceMemberEvent {
  final String workspaceId;

  const GetWorkspaceMembersEvent({required this.workspaceId});
}

class AddWorkspaceMemberEvent extends WorkspaceMemberEvent {
  final String workspaceId;
  final String email;
  final String role;

  const AddWorkspaceMemberEvent({required this.workspaceId, required this.email, required this.role});
}

class RemoveWorkspaceMemberEvent extends WorkspaceMemberEvent {
  final String workspaceId;
  final String email;

  const RemoveWorkspaceMemberEvent({required this.workspaceId, required this.email});
}

class UpdateWorkspaceMemberEvent extends WorkspaceMemberEvent {
  final String workspaceId;
  final String email;
  final String role; 
  
  const UpdateWorkspaceMemberEvent({required this.workspaceId, required this.email, required this.role});
}

class GetWorkspaceMemberEvent extends WorkspaceMemberEvent {
  final String workspaceId;
  final String email;

  const GetWorkspaceMemberEvent({required this.workspaceId, required this.email});
}