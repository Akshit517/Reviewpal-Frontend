part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfile extends ProfileEvent {
  const GetProfile();
}

class UpdateProfilePic extends ProfileEvent {
  final String profilePic;
  const UpdateProfilePic({required this.profilePic});
}

class UpdateUsername extends ProfileEvent {
  final String username;
  const UpdateUsername({required this.username});
}
