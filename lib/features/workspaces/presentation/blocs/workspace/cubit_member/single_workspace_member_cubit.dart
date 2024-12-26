import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/workspace_member.dart';
import '../../../../domain/usecases/workspaces/workspace_member.dart';

part 'single_workspace_member_state.dart';

class SingleWorkspaceMemberCubit extends Cubit<SingleWorkspaceMemberState> {
  final GetWorkspaceMemberUseCase getWorkspaceMemberUseCase;

  SingleWorkspaceMemberCubit({
    required this.getWorkspaceMemberUseCase,
  }) : super(SingleWorkspaceMemberState());

  Future<void> getWorkspaceMember(String workspaceId, String email) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    
    final result = await getWorkspaceMemberUseCase(
      WorkspaceMemberParams(
        workspaceId: workspaceId, 
        userEmail: email,
      ));
    
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false, 
        isSuccess: false,
      )),
      (data) => emit(state.copyWith(
        member: data, 
        isLoading: false, 
        isSuccess: true,
      )),
    );
  }
}
