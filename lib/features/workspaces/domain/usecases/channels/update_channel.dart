import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/assignment/assignment_entity.dart';
import '../../entities/channel/channel_entity.dart';
import '../../repositories/workspace_repositories.dart';

class UpdateChannelUseCase implements UseCase<void, UpdateChannelParams>{
  final WorkspaceRepositories workspaceRepositories;

  UpdateChannelUseCase({required this.workspaceRepositories});

  @override
  Future<Either<Failure, Channel>> call(UpdateChannelParams params) async {
    return await workspaceRepositories.updateChannel(
      params.workspaceId,
      params.categoryId,
      params.channelId,
      params.name,
      params.assignmentData,
    );
  }
}

class UpdateChannelParams {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String? name;
  final Assignment assignmentData;

  UpdateChannelParams({required this.workspaceId, required this.categoryId, required this.channelId, this.name, required this.assignmentData});
}
