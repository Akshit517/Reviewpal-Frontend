import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FetchProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState()) {
    on<GetProfile>((event, emit) async {
      emit(state.copyWith(status: () => Status.loading));
      final result = await getProfileUseCase(NoParams());
      emit(state.copyWith(status: () => Status.loading));
      result.fold(
        (failure) => emit(state.copyWith(
            status: () => Status.failure, failure: () => failure)),
        (user) => emit(
            state.copyWith(status: () => Status.success, user: () => user)),
      );
    });
    on<UpdateProfilePic>((event, emit) async {
      emit(state.copyWith(status: () => Status.loading));

      final result = await updateProfileUseCase(
          ProfileParams(profilePic: event.profilePic));
      result.fold(
        (failure) => emit(state.copyWith(
            status: () => Status.failure, failure: () => failure)),
        (user) => emit(
            state.copyWith(status: () => Status.success, user: () => user)),
      );
    });
    on<UpdateUsername>((event, emit) async {
      emit(state.copyWith(status: () => Status.loading));
      final result =
          await updateProfileUseCase(ProfileParams(username: event.username));

      result.fold(
        (failure) => emit(state.copyWith(
            status: () => Status.failure, failure: () => failure)),
        (user) => emit(
            state.copyWith(status: () => Status.success, user: () => user)),
      );
    });
  }
}
