part of 'channel_bloc.dart';

// ignore: must_be_immutable
class ChannelState extends Equatable {
  final Map<int, List<Channel>> channelsByCategory;
  final String? message;
  final bool? isLoading;
  final bool? isSuccess;

  const ChannelState({
    this.channelsByCategory = const {},
    this.isLoading,
    this.isSuccess,
    this.message
  });

  @override
  List<Object?> get props => [channelsByCategory, message, isLoading, isSuccess];

  ChannelState copyWith({
    Map<int, List<Channel>>? channelsByCategory,
    String? message,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return ChannelState(
      channelsByCategory: channelsByCategory ?? this.channelsByCategory,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }
}
