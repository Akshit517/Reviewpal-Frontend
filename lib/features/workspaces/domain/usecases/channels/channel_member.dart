import 'package:ReviewPal/core/usecases/usecases.dart';
import 'package:ReviewPal/features/workspaces/domain/entities/channel_member.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/workspace_repositories.dart';

class GetChannelMemberUseCase implements UseCase<List<ChannelMember>, ChannelMemberParams>{
  final WorkspaceRepositories repository;

  GetChannelMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChannelMember>>> call(ChannelMemberParams params) async {
    return await repository.getChannelMembers(
      params.workspaceId, 
      params.categoryId, 
      params.channelId
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
      params.email,
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
      params.email, 
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
      params.email, 
    );
  }
}

class ChannelMemberParams {
  final String workspaceId;
  final String categoryId;
  final String channelId;
  final String email;
  final String? role;

  ChannelMemberParams({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    required this.email,
    this.role
  });
}