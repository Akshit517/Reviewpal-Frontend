import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../../domain/usecases/workspaces/create_worksapce.dart';
import '../../../domain/usecases/workspaces/delete_workspace.dart';
import '../../../domain/usecases/workspaces/get_joined_workspaces.dart';
import '../../../domain/usecases/workspaces/get_workspace.dart';
import '../../../domain/usecases/workspaces/update_workspace.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final CreateWorkspace createWorkspace;
  final DeleteWorkspace deleteWorkspace;
  final UpdateWorkspace updateWorkspace;
  final GetWorkspace getWorkspace;
  final GetJoinedWorkspaces getJoinedWorkspaces;

  WorkspaceBloc({
    required this.createWorkspace,
    required this.deleteWorkspace,
    required this.updateWorkspace,
    required this.getWorkspace,
    required this.getJoinedWorkspaces,
  }) : super(WorkspaceInitial()) {
    on<CreateWorkspaceEvent>(_onCreateWorkspace);
    on<DeleteWorkspaceEvent>(_onDeleteWorkspace);
    on<UpdateWorkspaceEvent>(_onUpdateWorkspace);
    on<GetWorkspaceEvent>(_onGetWorkspace);
    on<GetJoinedWorkspacesEvent>(_onGetJoinedWorkspaces);
  }

  Future<void> _onCreateWorkspace(
      CreateWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    emit(WorkspaceLoading());
    final result = await createWorkspace(event.name, event.icon);
    result.fold(
      (failure) => emit(WorkspaceError(message: _mapFailureToMessage(failure))),
      (workspace) => emit(WorkspaceCreated(workspace)),
    );
  }

  Future<void> _onDeleteWorkspace(
      DeleteWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    emit(WorkspaceLoading());
    final result = await deleteWorkspace(event.workspaceId);
    result.fold(
      (failure) => emit(WorkspaceError(message: _mapFailureToMessage(failure))),
      (_) => emit(WorkspaceDeleted()),
    );
  }

  Future<void> _onUpdateWorkspace(
      UpdateWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    emit(WorkspaceLoading());
    final result =
        await updateWorkspace(event.workspaceId, event.name, event.icon);
    result.fold(
      (failure) => emit(WorkspaceError(message: _mapFailureToMessage(failure))),
      (workspace) => emit(WorkspaceUpdated(workspace)),
    );
  }

  Future<void> _onGetWorkspace(
      GetWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    emit(WorkspaceLoading());
    final result = await getWorkspace(event.workspaceId);
    result.fold(
      (failure) => emit(WorkspaceError(message: _mapFailureToMessage(failure))),
      (workspace) => emit(WorkspaceLoaded(workspace)),
    );
  }

  Future<void> _onGetJoinedWorkspaces(
      GetJoinedWorkspacesEvent event, Emitter<WorkspaceState> emit) async {
    emit(WorkspaceLoading());
    final result = await getJoinedWorkspaces();
    result.fold(
      (failure) => emit(WorkspaceError(message: _mapFailureToMessage(failure))),
      (workspaces) => emit(WorkspacesLoaded(workspaces)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is UnauthorizedFailure) {
      return 'Unauthorized Access';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else {
      return 'Unexpected Error';
    }
  }
}
