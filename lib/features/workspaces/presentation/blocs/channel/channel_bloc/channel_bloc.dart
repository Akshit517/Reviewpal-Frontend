import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/assignment_entity.dart';
import '../../../../domain/entities/channel_entity.dart';
import '../../../../domain/usecases/channels/create_channel.dart';
import '../../../../domain/usecases/channels/delete_channel.dart';
import '../../../../domain/usecases/channels/get_channels.dart';
import '../../../../domain/usecases/channels/update_channel.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final GetChannelsUseCase getChannels;
  final CreateChannelUseCase createChannel;
  final UpdateChannelUseCase updateChannel;
  final DeleteChannelUseCase deleteChannel;


  ChannelBloc({
    required this.getChannels,
    required this.createChannel,
    required this.updateChannel,
    required this.deleteChannel
  }) : super(const ChannelState()) {
    on<GetChannelsEvent>(_getChannels);
    on<CreateChannelEvent>(_createChannel);
    on<UpdateChannelEvent>(_updateChannel);
    on<DeleteChannelEvent>(_deleteChannel);
  }

  Future<void> _getChannels(GetChannelsEvent event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getChannels(
      ChannelParams(
        workspaceId: event.workspaceId, 
        categoryId: event.categoryId
      ));
    
    result.fold(
      (failure) => emit(state.copyWith(
        message: _mapFailureToMessage(failure), 
        isSuccess: false, 
        isLoading: false
      )),
      (channels) {
        final updatedChannels = Map<int, List<Channel>>.from(state.channelsByCategory);
        updatedChannels[event.categoryId] = channels;
        
        emit(state.copyWith(
          channelsByCategory: updatedChannels,
          isSuccess: true,
          isLoading: false
        ));
      },
    );
  }

  Future<void> _createChannel(CreateChannelEvent event, Emitter<ChannelState> emit) async {
  emit(state.copyWith(isLoading: true));
  final result = await createChannel(
    CreateChannelParams(
      workspaceId: event.workspaceId,
      categoryId: event.categoryId,
      name: event.name,
      assignmentData: event.assignment
    )
  );

  result.fold(
    (failure) => emit(state.copyWith(
      message: _mapFailureToMessage(failure), 
      isSuccess: false, 
      isLoading: false
    )),
    (channel) {
      final updatedChannels = Map<int, List<Channel>>.from(state.channelsByCategory);
      final categoryChannels = updatedChannels[event.categoryId] ?? [];
      updatedChannels[event.categoryId] = [...categoryChannels, channel];
      
      emit(state.copyWith(
        channelsByCategory: updatedChannels,
        message: "Channel created successfully",
        isSuccess: true,
        isLoading: false
      ));
    }
  );
}

  Future<void> _updateChannel(UpdateChannelEvent event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateChannel(
      UpdateChannelParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        channelId: event.channelId,
        name: event.name,
        assignmentData: event.assignment!
      )
    );
    
    result.fold(
      (failure) => emit(state.copyWith(
        message: _mapFailureToMessage(failure), 
        isSuccess: false, 
        isLoading: false
      )),
      (channel) {
        final updatedChannels = Map<int, List<Channel>>.from(state.channelsByCategory);
        final categoryChannels = updatedChannels[event.categoryId] ?? [];
        updatedChannels[event.categoryId] = categoryChannels.map(
          (e) => e.id == channel.id ? channel : e
        ).toList();

        emit(state.copyWith(
          channelsByCategory: updatedChannels,
          message: "Channel updated successfully",
          isSuccess: true,
          isLoading: false
        ));
      }
    );
  }


  Future<void> _deleteChannel(DeleteChannelEvent event, Emitter<ChannelState> emit) async {
  emit(state.copyWith(isLoading: true));
  final result = await deleteChannel(
    ChannelParams(
      workspaceId: event.workspaceId,
      categoryId: event.categoryId,
      channelId: event.channelId
    )
  );
  
  result.fold(
    (failure) => emit(state.copyWith(
      message: _mapFailureToMessage(failure), 
      isSuccess: false, 
      isLoading: false
    )),
    (_) {
      final updatedChannels = Map<int, List<Channel>>.from(state.channelsByCategory);
      final categoryChannels = updatedChannels[event.categoryId] ?? [];
      updatedChannels[event.categoryId] = categoryChannels
          .where((channel) => channel.id != event.channelId)
          .toList();

      emit(state.copyWith(
        channelsByCategory: updatedChannels,
        message: "Channel deleted successfully",
        isSuccess: true,
        isLoading: false
      ));
    }
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
