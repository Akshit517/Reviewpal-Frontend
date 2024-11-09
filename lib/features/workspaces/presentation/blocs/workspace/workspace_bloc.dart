import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc() : super(WorkspaceInitial()) {
    on<WorkspaceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
