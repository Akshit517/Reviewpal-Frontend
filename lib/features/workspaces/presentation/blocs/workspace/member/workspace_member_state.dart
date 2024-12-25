part of 'workspace_member_bloc.dart';

sealed class WorkspaceMemberState extends Equatable {
  const WorkspaceMemberState();
  
  @override
  List<Object> get props => [];
}

final class WorkspaceMemberInitial extends WorkspaceMemberState {}

final class WorkspaceMemberLoading extends WorkspaceMemberState {}

final class WorkspaceMemberSuccess extends WorkspaceMemberState {
  final List<WorkspaceMember>? members;
  final WorkspaceMember? member;

  const WorkspaceMemberSuccess({this.members, this.member});
}

final class WorkspaceMemberError extends WorkspaceMemberState {
  final String message;

  const WorkspaceMemberError({required this.message});
}