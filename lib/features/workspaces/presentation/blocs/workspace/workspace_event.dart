part of 'workspace_bloc.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object> get props => [];
}

class CreateWorkspaceEvent extends WorkspaceEvent {
  final String name;
  final String icon;

  const CreateWorkspaceEvent({required this.name, required this.icon});

  @override
  List<Object> get props => [name, icon];
}

class DeleteWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;

  const DeleteWorkspaceEvent(this.workspaceId);

  @override
  List<Object> get props => [workspaceId];
}

class UpdateWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;
  final String name;
  final String icon;

  const UpdateWorkspaceEvent(this.workspaceId, this.name, this.icon);

  @override
  List<Object> get props => [workspaceId, name, icon];
}

class GetWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;

  const GetWorkspaceEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

class GetJoinedWorkspacesEvent extends WorkspaceEvent {
  const GetJoinedWorkspacesEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends WorkspaceEvent {
  final String workspaceId;

  const GetCategoriesEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}
