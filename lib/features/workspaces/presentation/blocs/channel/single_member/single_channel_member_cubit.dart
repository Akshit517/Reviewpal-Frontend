import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/channel_member.dart';
import '../../../../domain/usecases/channels/channel_member.dart';

part 'single_channel_member_state.dart';

class SingleChannelMemberCubit extends Cubit<SingleChannelMemberState> {
  final GetChannelMemberUseCase getChannelMemberUseCase;

  SingleChannelMemberCubit({
    required this.getChannelMemberUseCase,
  }) : super(SingleChannelMemberState());

  Future<void> getChannelMember(String workspaceId, int categoryId, String channelId, String email) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    
    final result = await getChannelMemberUseCase(
      ChannelMemberParams(
        workspaceId: workspaceId, 
        categoryId: categoryId,
        channelId: channelId,
        email: email,
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