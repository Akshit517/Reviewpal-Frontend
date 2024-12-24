part of 'channel_bloc.dart';

sealed class ChannelState extends Equatable {
  const ChannelState();
  
  @override
  List<Object> get props => [];
}

final class ChannelInitial extends ChannelState {}

final class ChannelLoading extends ChannelState {}

final class ChannelSuccess extends ChannelState {
  final String message;

  const ChannelSuccess({required this.message});
}

final class ChannelError extends ChannelState {
  final String message;

  const ChannelError({required this.message});
}

final class ChannelsLoaded extends ChannelState {
  final List<Channel> channels;

  const ChannelsLoaded({required this.channels});
}