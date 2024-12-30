import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/channel/channel_member.dart';
import '../../../../domain/usecases/channels/channel_member.dart';

part 'single_channel_member_state.dart';

class SingleChannelMemberCubit extends Cubit<SingleChannelMemberState> {
  final GetChannelMemberUseCase getChannelMemberUseCase;

  SingleChannelMemberCubit({
    required this.getChannelMemberUseCase,
  }) : super(const SingleChannelMemberState());

  Future<void> getChannelMember(
    String workspaceId,
    int categoryId,
    String channelId,
    String email,
  ) async {
    final String key = '$workspaceId-$categoryId-$channelId';
    
    emit(state.copyWith(
      loadingStates: {...state.loadingStates, key: true},
      successStates: {...state.successStates, key: false},
    ));

    final result = await getChannelMemberUseCase(
      ChannelMemberParams(
        workspaceId: workspaceId,
        categoryId: categoryId,
        channelId: channelId,
        email: email,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        loadingStates: {...state.loadingStates, key: false},
        successStates: {...state.successStates, key: false},
      )),
      (data) => emit(state.copyWith(
        members: {...state.members, key: data},
        loadingStates: {...state.loadingStates, key: false},
        successStates: {...state.successStates, key: true},
      )),
    );
  }
}