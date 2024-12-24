import 'package:ReviewPal/features/auth/data/datasources/user_local_data_source.dart';
import 'package:ReviewPal/features/workspaces/data/datasources/remote_data_source.dart';
import 'package:ReviewPal/features/workspaces/domain/entities/submission.dart';
import 'package:ReviewPal/features/workspaces/domain/repositories/workspace_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_member.dart';
import '../../domain/entities/channel_entity.dart';
import '../../domain/entities/channel_member.dart';
import '../../domain/entities/review_iteration.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/entities/workspace_member.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepositories {
  final WorkspaceRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource, required this.userLocalDataSource});

  Failure _handleException(Object e) {
    if (e is UnAuthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return const ServerFailure();
    } else {
      return const GeneralFailure();
    }
  }

  @override
  Future<Either<Failure, Workspace>> createWorkspace(String name, String icon) async {
    try {
      final workspaceModel = await remoteDataSource.createWorkspace(name: name, icon: icon);
      return Right(workspaceModel);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId) async {
    try {
      await remoteDataSource.deleteWorkspace(workspaceId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace(String workspaceId, String name, String icon) async {
    try {
      final updatedWorkspace = await remoteDataSource.updateWorkspace(
        workspaceId: workspaceId,
        name: name,
        icon: icon,
      );
      return Right(updatedWorkspace);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  //@override
  //Future<Either<Failure, void>> leaveWorkspace(String workspaceId) async {
  //  try {
  //     final user = await userLocalDataSource.getCachedUser();
  //     final email = user.email;
  //     await remoteDataSource.removeWorkspaceMember(
  //      workspaceId: workspaceId, 
  //      userEmail: email);
  //     return const Right(null);
  //  }
  //  catch (e) {
  //    return Left(_handleException(e));
  //  }
  //}

  @override
  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces() async {
    try {
      final workspaces = await remoteDataSource.fetchWorkspaces();
      return Right(workspaces.map((e) => e).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(String workspaceId) async {
    try {
      final workspace = await remoteDataSource.getWorkspace(workspaceId: workspaceId);
      return Right(workspace);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addWorkspaceMember(String workspaceId, String userEmail, String role) async {
    try {
      await remoteDataSource.sendWorkspaceInvite(
        workspaceId: workspaceId,
        userEmail: userEmail,
        role: role,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeWorkspaceMember(String workspaceId, String userEmail) async {
    try {
      await remoteDataSource.removeWorkspaceMember(
        workspaceId: workspaceId,
        userEmail: userEmail,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<WorkspaceMember>>> getWorkspaceMembers(String workspaceId) async {
    try {
      final members = await remoteDataSource.fetchWorkspaceMembers(workspaceId);
      return Right(members);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // Commented as not implemented
  // @override
  // Future<Either<Failure, WorkspaceMember>> getWorkspaceMember(String workspaceId, String email) {
  //   // TODO: Implement this method
  // }

  @override
  Future<Either<Failure, void>> updateWorkspaceMember(String workspaceId, String email, String role) async {
    try {
      await remoteDataSource.updateWorkspaceMember(workspaceId, email, role);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories(String workspaceId) async {
    try {
      final categories = await remoteDataSource.fetchCategories(workspaceId);
      return Right(categories.map((e) => e).toList());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(String workspaceId, String name) async {
    try {
      final category = await remoteDataSource.createCategory(workspaceId, name);
      return Right(category);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String workspaceId, String id) async {
    try {
      await remoteDataSource.deleteCategory(workspaceId, id);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(String workspaceId, String id, String name) async {
    try {
      final category = await remoteDataSource.updateCategory(workspaceId, id, name);
      return Right(category);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<CategoryMember>>> getCategoryMembers(String workspaceId, String id) async {
    try {
      final members = await remoteDataSource.getCategoryMembers(workspaceId, id);
      return Right(members);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addMemberToCategory(String workspaceId, String id, String email) async {
    try {
      await remoteDataSource.addMemberToCategory(workspaceId, id, email);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeMemberFromCategory(String workspaceId, String id, String email) async {
    try {
      await remoteDataSource.removeMemberFromCategory(workspaceId, id, email);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, CategoryMember>> getCategoryMember(String workspaceId, String id, String email) async {
    try {
      final member = await remoteDataSource.getCategoryMember(workspaceId, id, email);
      return Right(member);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategoryMember(String workspaceId, String id, String email, String role) async {
    try {
      await remoteDataSource.updateCategoryMember(workspaceId, id, email, role);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Channel>>> getChannels(String workspaceId, String categoryId) async {
    try {
      final channels = await remoteDataSource.fetchChannels(workspaceId, categoryId);
      return Right(channels);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> createChannel(String workspaceId, String categoryId, String name, Assignment assignment) async {
    try {
      final channel = await remoteDataSource.createChannel(workspaceId, categoryId, name, assignment);
      return Right(channel);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChannel(String workspaceId, String categoryId, String channelId) async {
    try {
      await remoteDataSource.deleteChannel(workspaceId, categoryId, channelId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateChannel(String workspaceId, String categoryId, String channelId, String? name, Assignment assignment) async {
    try {
      await remoteDataSource.updateChannel(workspaceId, categoryId, channelId, name, assignment);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ChannelMember>>> getChannelMembers(String workspaceId, String categoryId, String channelId) async {
    try {
      final members = await remoteDataSource.getChannelMembers(workspaceId, categoryId, channelId);
      return Right(members);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addMemberToChannel(String workspaceId, String categoryId, String channelId, String email) async {
    try {
      await remoteDataSource.addMemberToChannel(workspaceId, categoryId, channelId, email);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeMemberFromChannel(String workspaceId, String categoryId, String channelId, String email) async {
    try {
      await remoteDataSource.removeMemberFromChannel(workspaceId, categoryId, channelId, email);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Assignment>> getAssignment(String workspaceId, String categoryId, String channelId) async {
    try {
      final assignment = await remoteDataSource.getAssignment(workspaceId, categoryId, channelId);
      return Right(assignment);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateAssignment(String workspaceId, String categoryId, String channelId, Assignment assignment) async {
    try {
      await remoteDataSource.updateAssignment(workspaceId, categoryId, channelId, assignment);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Submission>>> getSubmissionReviewees(String workspaceId, String categoryId, String channelId) async {
    try {
      final submissions = await remoteDataSource.getSubmissionReviewees(workspaceId, categoryId, channelId);
      return Right(submissions);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Submission>>> createSubmissionReviewee(String workspaceId, String categoryId, String channelId, String? content, String? file) async {
    try {
      final submissions = await remoteDataSource.postSubmissionReviewee(workspaceId, categoryId, channelId, content, file);
      return Right(submissions);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Submission>>> getSubmissionByUserId(String workspaceId, String categoryId, String channelId, String userId) async {
    try {
      final submissions = await remoteDataSource.getSubmissionByUserId(workspaceId, categoryId, channelId, userId);
      return Right(submissions);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  /// [Iteration] Methods
  @override
  Future<Either<Failure, ReviewIteration>> getReviewerIteration(String workspaceId, String categoryId, String channelId, String submissionId) async {
    try {
      final iteration = await remoteDataSource.getReviewerIteration(workspaceId, categoryId, channelId, submissionId);
      return Right(iteration);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  

}