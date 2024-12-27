part of 'single_channel_member_cubit.dart';

class SingleChannelMemberState extends Equatable {
  final Map<String, ChannelMember> members;
  final Map<String, bool> loadingStates;
  final Map<String, bool> successStates;

  const SingleChannelMemberState({
    this.members = const {},
    this.loadingStates = const {},
    this.successStates = const {},
  });

  SingleChannelMemberState copyWith({
    Map<String, ChannelMember>? members,
    Map<String, bool>? loadingStates,
    Map<String, bool>? successStates,
  }) {
    return SingleChannelMemberState(
      members: members ?? this.members,
      loadingStates: loadingStates ?? this.loadingStates,
      successStates: successStates ?? this.successStates,
    );
  }

  @override
  List<Object?> get props => [members, loadingStates, successStates];
}