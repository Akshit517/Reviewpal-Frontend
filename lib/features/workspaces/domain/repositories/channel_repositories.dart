import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../entities/assignment_entity.dart';
import '../entities/channel_entity.dart';

abstract class ChannelRepositories {

  Either<Failure, List<Channel>> getChannels(String workspaceId, String categoryId, String accessToken);

  Either<Failure, Channel> createChannel(String workspaceId, String categoryId, String name, Assignment assignmentData, String accessToken);

  Either<Failure, void> deleteChannel(String workspaceId, String categoryId, String channelId, String accessToken);

  Either<Failure, Channel> updateChannel(String workspaceId, String categoryId, String channelId, String accessToken, String? name, Assignment? assignmentData);

  Either<Failure, Channel> getChannel(String workspaceId, String categoryId, String channelId, String accessToken);

  Either<Failure, List<User>> getChannelMembers(String workspaceId, String categoryId, String channelId, String accessToken);
  Either<Failure, void> addMemberToChannel(String workspaceId, String categoryId, String channelId, String email, String accessToken);
  Either<Failure, void> removeMemberFromChannel(String workspaceId, String categoryId, String channelId, String email, String accessToken);
}