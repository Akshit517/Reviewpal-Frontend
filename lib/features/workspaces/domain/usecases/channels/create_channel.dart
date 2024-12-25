import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../entities/assignment_entity.dart';
import '../../entities/channel_entity.dart';
import '../../repositories/workspace_repositories.dart';

class CreateChannelUseCase implements UseCase<void, CreateChannelParams> {
  final WorkspaceRepositories repository;

  CreateChannelUseCase({required this.repository});

  @override
  Future<Either<Failure, Channel>> call(CreateChannelParams params) async {
    return await repository.createChannel(
      params.workspaceId,
      params.categoryId,
      params.name,
      params.assignmentData,
    );
  }
}

class CreateChannelParams {
  final String workspaceId;
  final int categoryId;
  final String name;
  final Assignment assignmentData;

  CreateChannelParams({
    required this.workspaceId,
    required this.categoryId,
    required this.name,
    required this.assignmentData,
  });
}