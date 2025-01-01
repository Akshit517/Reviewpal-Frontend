import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/channel/channel_member.dart';
import '../../../../domain/usecases/channels/channel_member.dart';

part 'channel_member_event.dart';
part 'channel_member_state.dart';

class ChannelMemberBloc extends Bloc<ChannelMemberEvent, ChannelMemberState> {
  final GetChannelMembersUseCase getChannelMembersUseCase;
  final AddChannelMemberUseCase addChannelMemberUseCase;
  final DeleteChannelMemberUseCase deleteChannelMemberUseCase;
  final UpdateChannelMemberUseCase updateChannelMemberUseCase;

  ChannelMemberBloc({
    required this.getChannelMembersUseCase,
    required this.addChannelMemberUseCase,
    required this.deleteChannelMemberUseCase,
    required this.updateChannelMemberUseCase
  }) : super(ChannelMemberInitial()) {
    on<GetChannelMembersEvent>(_getChannelMembers);
    on<AddChannelMemberEvent>(_addChannelMember);
    on<RemoveChannelMemberEvent>(_deleteChannelMember);
    on<UpdateChannelMemberEvent>(_updateChannelMember);
  }

  void _getChannelMembers(GetChannelMembersEvent event, Emitter<ChannelMemberState> emit) async {
    emit(ChannelMemberLoading());
    final result = await getChannelMembersUseCase(
      ChannelMemberParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId
      )
    );
    result.fold(
      (failure) => emit(ChannelMemberError(message: failure.message)),
      (members) => emit(ChannelMemberSuccess(members: members))
    );
  }

  void _addChannelMember(AddChannelMemberEvent event, Emitter<ChannelMemberState> emit) async {
    emit(ChannelMemberLoading());
    final result = await addChannelMemberUseCase(
      ChannelMemberParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        email: event.userEmail,
        role: event.role
      )
    );
    result.fold(
      (failure) => emit(ChannelMemberError(message: failure.message)),
      (message) => emit(const ChannelMemberSuccess())
    );
  }

  void _deleteChannelMember(RemoveChannelMemberEvent event, Emitter<ChannelMemberState> emit) async {
    emit(ChannelMemberLoading());
    final result = await deleteChannelMemberUseCase(
      ChannelMemberParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        email: event.userEmail
      )
    );
    result.fold(
      (failure) => emit(ChannelMemberError(message: failure.message)),
      (message) => emit(const ChannelMemberSuccess())
    );
  }

  void _updateChannelMember(UpdateChannelMemberEvent event, Emitter<ChannelMemberState> emit) async {
    emit(ChannelMemberLoading());
    final result = await updateChannelMemberUseCase(
      ChannelMemberParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        email: event.userEmail,
        role: event.role
      )
    );
    result.fold(
      (failure) => emit(ChannelMemberError(message: failure.message)),
      (message) => emit(const ChannelMemberSuccess())
    );
  }
}
