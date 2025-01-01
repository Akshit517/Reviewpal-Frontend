import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../repositories/workspace_repositories.dart';
import 'get_channels.dart';

class DeleteChannelUseCase implements UseCase<void, ChannelParams> {
  final WorkspaceRepositories repository;

  DeleteChannelUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChannelParams params) async {
    return await repository.deleteChannel(params.workspaceId, params.categoryId, params.channelId!);
  }
}