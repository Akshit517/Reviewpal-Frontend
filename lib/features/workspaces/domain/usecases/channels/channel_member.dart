import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/channel/channel_member.dart';
import '../../repositories/workspace_repositories.dart';

class GetChannelMembersUseCase implements UseCase<List<ChannelMember>, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  GetChannelMembersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChannelMember>>> call(ChannelMemberParams params) async {
    return await repository.getChannelMembers(
      params.workspaceId, 
      params.categoryId, 
      params.channelId
    );
  }
}

class GetChannelMemberUseCase implements UseCase<ChannelMember, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  GetChannelMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, ChannelMember>> call(ChannelMemberParams params) async {
    return await repository.getChannelMember(
      params.workspaceId, 
      params.categoryId, 
      params.channelId, 
      params.email!
    );
  }
}

class AddChannelMemberUseCase implements UseCase<void, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  AddChannelMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChannelMemberParams params) async {
    return await repository.addMemberToChannel(
      params.workspaceId, 
      params.categoryId, 
      params.channelId, 
      params.email!,
      params.role!  
    );
  }
}

class UpdateChannelMemberUseCase implements UseCase<void, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  UpdateChannelMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChannelMemberParams params) async {
    return await repository.updateChannelMember(
      params.workspaceId, 
      params.categoryId, 
      params.channelId, 
      params.email!, 
      params.role!
    );
  }
}

class DeleteChannelMemberUseCase implements UseCase<void, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  DeleteChannelMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChannelMemberParams params) async {
    return await repository.removeMemberFromChannel(
      params.workspaceId, 
      params.categoryId, 
      params.channelId, 
      params.email!, 
    );
  }
}

class ChannelMemberParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String? email;
  final String? role;

  ChannelMemberParams({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    this.email,
    this.role
  });
}