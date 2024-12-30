part of 'single_workspace_member_cubit.dart';

// ignore: must_be_immutable
class SingleWorkspaceMemberState extends Equatable {
  WorkspaceMember? member; 
  bool? isLoading;
  bool? isSuccess;
  SingleWorkspaceMemberState({
    this.member,
    this.isLoading,
    this.isSuccess,
  });

  @override
  List<Object?> get props => [member, isLoading, isSuccess];

  SingleWorkspaceMemberState copyWith({
    WorkspaceMember? member,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return SingleWorkspaceMemberState(
      member: member ?? this.member,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}