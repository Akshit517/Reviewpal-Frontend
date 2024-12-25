import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/assignment_entity.dart';
import '../entities/assignment_status.dart';
import '../entities/category_entity.dart';
import '../entities/category_member.dart';
import '../entities/channel_entity.dart';
import '../entities/channel_member.dart';
import '../entities/review_iteration.dart';
import '../entities/review_iteration_response.dart';
import '../entities/submission.dart';
import '../entities/workspace_entity.dart';
import '../entities/workspace_member.dart';

abstract class WorkspaceRepositories {
  /// [Workspace] methods
  Future<Either<Failure, Workspace>> createWorkspace(String name, String icon);
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId);
  Future<Either<Failure, Workspace>> updateWorkspace(String workspaceId, String name, String icon);
  Future<Either<Failure, List<Workspace>>> getJoinedWorkspaces();
  Future<Either<Failure, Workspace>> getWorkspace(String workspaceId);
  Future<Either<Failure, void>> addWorkspaceMember(String workspaceId, String userEmail, String role);
  Future<Either<Failure, void>> removeWorkspaceMember(String workspaceId, String userEmail);
  Future<Either<Failure, List<WorkspaceMember>>> getWorkspaceMembers(String workspaceId);
  Future<Either<Failure, WorkspaceMember>> getWorkspaceMember(String workspaceId, String email);
  Future<Either<Failure, void>> updateWorkspaceMember(String workspaceId, String email, String role);

  // Commented as not implemented
  // Future<Either<Failure, void>> leaveWorkspace(String workspaceId);

  /// [Category] methods
  Future<Either<Failure, List<Category>>> getCategories(String workspaceId);
  Future<Either<Failure, Category>> createCategory(String workspaceId, String name);
  Future<Either<Failure, void>> deleteCategory(String workspaceId, int id);
  Future<Either<Failure, Category>> updateCategory(String workspaceId, int id, String name);
  Future<Either<Failure, List<CategoryMember>>> getCategoryMembers(String workspaceId, int id);
  Future<Either<Failure, void>> addMemberToCategory(String workspaceId, int id, String email);
  Future<Either<Failure, void>> removeMemberFromCategory(String workspaceId, int id, String email);
  Future<Either<Failure, CategoryMember>> getCategoryMember(String workspaceId, int id, String email);
  Future<Either<Failure, void>> updateCategoryMember(String workspaceId, int id, String email, String role);

  /// [Channel] methods
  Future<Either<Failure, Channel>> createChannel(String workspaceId, int categoryId, String name, Assignment assignmentData);
  Future<Either<Failure, Channel>> updateChannel(String workspaceId, int categoryId, String channelId, String? name, Assignment assignmentData);
  Future<Either<Failure, List<Channel>>> getChannels(String workspaceId, int categoryId);
  Future<Either<Failure, void>> deleteChannel(String workspaceId, int categoryId, String channelId);
  Future<Either<Failure, List<ChannelMember>>> getChannelMembers(String workspaceId, int categoryId, String channelId);
  Future<Either<Failure, ChannelMember>> getChannelMember(String workspaceId, int categoryId, String channelId, String email);
  Future<Either<Failure, void>> addMemberToChannel(String workspaceId, int categoryId, String channelId, String email, String role);
  Future<Either<Failure, void>> removeMemberFromChannel(String workspaceId, int categoryId, String channelId, String email);
  Future<Either<Failure, void>> updateChannelMember(String workspaceId, int categoryId, String channelId, String email, String role);

  /// [Assignment] methods
  Future<Either<Failure, Assignment>> getAssignment(String workspaceId, int categoryId, String channelId);
  Future<Either<Failure, void>> updateAssignment(String workspaceId, int categoryId, String channelId, Assignment assignment);

  /// [Submission] methods
  Future<Either<Failure, List<Submission>>> getSubmissionReviewees(
      String workspaceId, int categoryId, String channelId);
  Future<Either<Failure, void>> createSubmissionReviewee(
      String workspaceId, int categoryId, String channelId,  String? content, String? file);
  Future<Either<Failure, List<Submission>>> getSubmissionByUserId(
      String workspaceId, int categoryId, String channelId, String userId);
  // Submission Reviewee methods (to be implemented)
  //Future<Either<Failure, void>> updateSubmissionReviewee(
  //    String workspaceId, int categoryId, String channelId, Map<String, dynamic> data);
  // Future<Either<Failure, void>> deleteSubmissionReviewee(
  //     String workspaceId, int categoryId, String channelId);

  Future<Either<Failure, ReviewIteration>> createIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
    String remarks,
    AssignmentStatus? assignmentStatus,
  );

  Future<Either<Failure, ReviewIteration>> getReviewerIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  );

  Future<Either<Failure, RevieweeIterationsResponse>> getRevieweeIterations(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  );
}
