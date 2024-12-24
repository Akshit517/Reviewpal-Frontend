import 'package:ReviewPal/features/workspaces/domain/entities/assignment_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/channel_entity.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  


  ChannelBloc() : super(ChannelInitial()) {
    on<GetChannelsEvent>(_getChannels);
    on<CreateChannelEvent>(_createChannel);
    on<UpdateChannelEvent>(_updateChannel);
    on<DeleteChannelEvent>(_deleteChannel);
  }

  void _getChannels(GetChannelsEvent event, Emitter<ChannelState> emit) {
    emit(ChannelLoadedState(event.channels));
  }
}
