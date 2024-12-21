part of 'workspace_bloc.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}
class WorkspacesLoading extends WorkspaceState {}
class WorkspaceCreated extends WorkspaceState {
  final Workspace workspace;

  const WorkspaceCreated(this.workspace);

  @override
  List<Object> get props => [workspace];
}

class WorkspaceDeleted extends WorkspaceState {}

class WorkspaceUpdated extends WorkspaceState {
  final Workspace workspace;

  const WorkspaceUpdated(this.workspace);

  @override
  List<Object> get props => [workspace];
}

class WorkspaceLoaded extends WorkspaceState {
  final Workspace workspace;

  const WorkspaceLoaded(this.workspace);

  @override
  List<Object> get props => [workspace];
}

class WorkspacesLoaded extends WorkspaceState {
  final List<Workspace> workspaces;

  const WorkspacesLoaded(this.workspaces);

  @override
  List<Object> get props => [workspaces];
}

class CategoriesLoaded extends WorkspaceState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}


class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError({required this.message});
}
