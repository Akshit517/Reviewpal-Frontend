part of 'profile_bloc.dart';

enum Status {
  initial,
  loading,
  success,
  failure,
}

class ProfileState extends Equatable {
  final Status status;
  final User? user;
  final Failure? failure;
  const ProfileState({this.status = Status.initial, this.user, this.failure});

  ProfileState copyWith({
    Status Function()? status,
    User? Function()? user,
    Failure? Function()? failure,
  }) {
    return ProfileState(
      status: status != null ? status() : this.status,
      user: user != null ? user() : this.user,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
