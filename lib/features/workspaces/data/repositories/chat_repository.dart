import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/user_local_data_source.dart';
import '../../domain/entities/message/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/group_chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GroupChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserLocalDataSource userLocalDataSource;

  ChatRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo,
      required this.userLocalDataSource});

  @override
  Future<Either<Failure, List<Message>>> getChannelMessages(
      String workspaceId, int categoryId, String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        final messages = await remoteDataSource.getChannelMessages(
            workspaceId, categoryId, channelId);
        return Right(messages);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Stream<Either<Failure, Message>> connectToChat(
      String workspaceId, int categoryId, String channelId) async* {
    if (await networkInfo.isConnected) {
      try {
        final token = await userLocalDataSource.getCachedToken();
        await for (final message in remoteDataSource.connectToChat(
            workspaceId, categoryId, channelId, token.accessToken)) {
          yield Right(message);
        }
      } on ServerException {
        yield const Left(ServerFailure());
      }
    } else {
      yield const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String message) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(message);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendFile(
      String filePath, String fileName) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendFile(filePath, fileName);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
