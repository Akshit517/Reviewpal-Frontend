part of 'channel_bloc.dart';

// ignore: must_be_immutable
class ChannelState extends Equatable {
  List<Channel> channels;
  String? message;
  bool? isLoading;
  bool? isSuccess;

  ChannelState({
    this.channels = const [],
    this.isLoading ,
    this.isSuccess ,
    this.message
  });
  
  @override
  List<Object> get props => [];

  ChannelState copyWith({
    List<Channel>? channels,
    String? message,
    bool? isLoading,
    bool? isSuccess,
  }){
    return ChannelState(
      channels: channels ?? this.channels,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }
}

// final class ChannelInitial extends ChannelState {}

// final class ChannelLoading extends ChannelState {}

// final class ChannelSuccess extends ChannelState {
//   final String message;

//   const ChannelSuccess({required this.message});
// }

// final class ChannelError extends ChannelState {
//   final String message;

//   const ChannelError({required this.message});
// }

// final class ChannelsLoaded extends ChannelState {
//   final List<Channel> channels;

//   const ChannelsLoaded({required this.channels});
// }