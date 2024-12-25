import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/channel_entity.dart';
import '../../repositories/workspace_repositories.dart';

class GetChannelsUseCase implements UseCase<List<Channel>, ChannelParams> {
  final WorkspaceRepositories repository;

  GetChannelsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Channel>>> call(ChannelParams params) async {
    return await repository.getChannels(params.workspaceId, params.categoryId);
  }
  
}

class ChannelParams {
  final String workspaceId;
  final int categoryId;
  final String? channelId;

  ChannelParams({
    required this.workspaceId,
    required this.categoryId,
    this.channelId,
  }); 
}