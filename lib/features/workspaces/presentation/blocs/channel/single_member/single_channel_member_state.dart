part of 'single_channel_member_cubit.dart';

// ignore: must_be_immutable
class SingleChannelMemberState extends Equatable {
  ChannelMember? member; 
  bool? isLoading;
  bool? isSuccess;
  SingleChannelMemberState({
    this.member,
    this.isLoading,
    this.isSuccess,
  });

  @override
  List<Object?> get props => [member, isLoading, isSuccess];

  SingleChannelMemberState copyWith({
    ChannelMember? member,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return SingleChannelMemberState(
      member: member ?? this.member,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}