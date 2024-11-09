part of 'workspace_bloc.dart';

sealed class WorkspaceState extends Equatable {
  const WorkspaceState();
  
  @override
  List<Object> get props => [];
}

final class WorkspaceInitial extends WorkspaceState {}
