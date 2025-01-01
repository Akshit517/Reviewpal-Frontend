import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/workspace/workspace_member.dart';
import '../../../../domain/usecases/workspaces/workspace_member.dart';

part 'workspace_member_event.dart';
part 'workspace_member_state.dart';

class WorkspaceMemberBloc extends Bloc<WorkspaceMemberEvent, WorkspaceMemberState> {
  final GetWorkspaceMembersUseCase getWorkspaceMembersUseCase;
  final AddWorkspaceMemberUseCase addWorkspaceMemberUseCase;
  final DeleteWorkspaceMemberUseCase deleteWorkspaceMemberUseCase;
  final UpdateWorkspaceMemberUseCase updateWorkspaceMemberUseCase;

  WorkspaceMemberBloc({
    required this.getWorkspaceMembersUseCase,
    required this.addWorkspaceMemberUseCase,
    required this.deleteWorkspaceMemberUseCase,
    required this.updateWorkspaceMemberUseCase,
  }) : super(WorkspaceMemberInitial()) {
    on<GetWorkspaceMembersEvent>(_getWorkspaceMembers);
    on<AddWorkspaceMemberEvent>(_addWorkspaceMember);
    on<RemoveWorkspaceMemberEvent>(_deleteWorkspaceMember);
    on<UpdateWorkspaceMemberEvent>(_updateWorkspaceMember);
  }

  Future<void> _getWorkspaceMembers(GetWorkspaceMembersEvent event, Emitter<WorkspaceMemberState> emit) async {
    emit(WorkspaceMemberLoading());
    final result = await getWorkspaceMembersUseCase(event.workspaceId);
    result.fold(
      (failure) => emit(WorkspaceMemberError(message: failure.message)),
      (data) => emit(WorkspaceMemberSuccess(members: data)),
    );
  }

  Future<void> _addWorkspaceMember(AddWorkspaceMemberEvent event, Emitter<WorkspaceMemberState> emit) async {
    emit(WorkspaceMemberLoading());
    final result = await addWorkspaceMemberUseCase(WorkspaceMemberParams(workspaceId: event.workspaceId, userEmail: event.email, role: event.role));
    result.fold(
      (failure) => emit(WorkspaceMemberError(message: failure.message)),
      (data) => emit(const WorkspaceMemberSuccess()),
    );
  }

  Future<void> _deleteWorkspaceMember(RemoveWorkspaceMemberEvent event, Emitter<WorkspaceMemberState> emit) async {
    emit(WorkspaceMemberLoading());
    final result = await deleteWorkspaceMemberUseCase(WorkspaceMemberParams(workspaceId: event.workspaceId, userEmail: event.email));
    result.fold(
      (failure) => emit(WorkspaceMemberError(message: failure.message)),
      (_) => emit(const WorkspaceMemberSuccess()),
    );
  }

  Future<void> _updateWorkspaceMember(UpdateWorkspaceMemberEvent event, Emitter<WorkspaceMemberState> emit) async {
    emit(WorkspaceMemberLoading());
    final result = await updateWorkspaceMemberUseCase(WorkspaceMemberParams(workspaceId: event.workspaceId, userEmail: event.email, role: event.role));
    result.fold(
      (failure) => emit(WorkspaceMemberError(message: failure.message)),
      (_) => emit(const WorkspaceMemberSuccess()),
    );
  }
}
