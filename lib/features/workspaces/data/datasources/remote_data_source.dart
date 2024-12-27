import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token/token_http_client.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/assignment_status.dart';
import '../models/assignment/assignment.dart';
import '../models/category/category.dart';
import '../models/category/category_member.dart';
import '../models/channel /channel.dart';
import '../models/channel /channel_member.dart';
import '../models/iteration/review_iteration_model.dart';
import '../models/iteration/review_iteration_response.dart';
import '../models/submission/submission.dart';
import '../models/workspaces/members.dart';
import '../models/workspaces/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  /// [Workspace] methods
  Future<List<WorkspaceModel>> fetchWorkspaces();
  Future<WorkspaceModel> createWorkspace({required String name,required String icon,});
  Future<WorkspaceModel> getWorkspace({required String workspaceId});
  Future<WorkspaceModel> updateWorkspace({required String workspaceId,required String name,required String icon});
  Future<void> deleteWorkspace(String workspaceId);

  /// [WorkspaceMember] methods
  Future<List<WorkspaceMemberModel>> fetchWorkspaceMembers(String workspaceId);
  Future<void> sendWorkspaceInvite({required String workspaceId,required String userEmail,required String role});
  Future<void> removeWorkspaceMember({required String workspaceId,required String userEmail});
  Future<void> updateWorkspaceMember(String workspaceId, String email, String role);
  Future<WorkspaceMemberModel> getWorkspaceMember(String workspaceId, String email);

  /// [Category] methods
  Future<CategoryModel> createCategory(String workspaceId, String name);
  Future<List<CategoryModel>> fetchCategories(String workspaceId);
  Future<CategoryModel> updateCategory(String workspaceId, int categoryId, String name);
  Future<void> deleteCategory(String workspaceId, int categoryId);

  /// [CategoryMember] methods
  Future<List<CategoryMemberModel>> getCategoryMembers(String workspaceId, int categoryId);
  Future<void> addMemberToCategory(String workspaceId, int categoryId, String email);
  Future<void> removeMemberFromCategory(String workspaceId, int categoryId, String email);
  Future<CategoryMemberModel> getCategoryMember(String workspaceId, int categoryId, String email);
  Future<void> updateCategoryMember(String workspaceId, int categoryId, String email, String role);

  /// [Channel] methods
  Future<ChannelModel> createChannel(String workspaceId, int categoryId, String name, Assignment assignment);
  Future<List<ChannelModel>> fetchChannels(String workspaceId, int categoryId);
  Future<ChannelMemberModel> getChannelMember(String workspaceId, int categoryId, String channelId, String email);
  Future<ChannelModel> updateChannel(String workspaceId, int categoryId, String channelId, String? name, Assignment assignment);
  Future<void> deleteChannel(String workspaceId, int categoryId, String channelId);

  /// [ChannelMember] methods
  Future<void> addMemberToChannel(String workspaceId, int categoryId, String channelId, String email, String role);
  Future<void> removeMemberFromChannel(String workspaceId, int categoryId, String channelId, String email);
  Future<List<ChannelMemberModel>> getChannelMembers(String workspaceId, int categoryId, String channelId);
  Future<void> updateChannelMember(String workspaceId, int categoryId, String channelId, String email, String role);

  /// [Assignment] methods
  Future<AssignmentModel> updateAssignment(String workspaceId, int categoryId, String channelId, Assignment assignment);
  Future<AssignmentModel> getAssignment(String workspaceId, int categoryId, String channelId);

  /// [SubmissionReviewee] methods
  Future<List<SubmissionModel>> getSubmissionReviewees(String workspaceId, int categoryId, String channelId);
  Future<List<SubmissionModel>> postSubmissionReviewee(String workspaceId, int categoryId, String channelId, String? content, String? file);

  /// [SubmissionReviewer] methods
  Future<List<SubmissionModel>> getSubmissionByUserId(String workspaceId, int categoryId, String channelId, String userId);

  /// [Iteration] methods
  Future<ReviewIterationModel> createIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
    String remarks,
    AssignmentStatus? assignmentStatus,
  );

  Future<ReviewIterationModel> getReviewerIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  );

  Future<RevieweeIterationsResponseModel> getRevieweeIterations(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  );
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final TokenHttpClient client;

  WorkspaceRemoteDataSourceImpl({required this.client});

  void _handleResponse(int statusCode) {
    if (statusCode == 401) {
      throw UnAuthorizedException();
    } else if (statusCode >= 400) {
      throw ServerException();
    }
  }

  /// [Workspace] Methods
  @override
  Future<List<WorkspaceModel>> fetchWorkspaces() async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => WorkspaceModel.fromJson(e)).toList();
  }

  @override
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String icon,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/',
      {'name': name, 'icon': icon},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return WorkspaceModel.fromJson(decodedJson);
  }

  @override
  Future<WorkspaceModel> getWorkspace({required String workspaceId}) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/');
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return WorkspaceModel.fromJson(decodedJson);
  }

  @override
  Future<WorkspaceModel> updateWorkspace({
    required String workspaceId,
    required String name,
    required String icon,
  }) async {
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/',
      {'name': name, 'icon': icon},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return WorkspaceModel.fromJson(decodedJson);
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    final response = await client.delete('${AppConstants.baseUrl}api/workspaces/$workspaceId/', null);
    _handleResponse(response.statusCode);
  }

  @override
  Future<List<WorkspaceMemberModel>> fetchWorkspaceMembers(String workspaceId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/members/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => WorkspaceMemberModel.fromJson(e)).toList();
  }

  @override
  Future<void> sendWorkspaceInvite({
    required String workspaceId,
    required String userEmail,
    required String role,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/members/',
      {'user_email': userEmail, 'role': role},
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String userEmail,
  }) async {
    final response = await client.delete(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/members/',
      {'user_email': userEmail},
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> updateWorkspaceMember(String workspaceId, String email, String role) async {
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/members/',
      {
        'user_email': email,
        'role': role
      },
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<WorkspaceMemberModel> getWorkspaceMember(String workspaceId, String email) async {
    final Uri uri = Uri.parse(
    '${AppConstants.baseUrl}api/workspaces/$workspaceId/members/')
    .replace(queryParameters: {'email': email});
    final response = await client.get(uri.toString());
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final Map<String, dynamic> memberJson = decodedJson.firstWhere(
      (element) => element['user']['email'] == email,
      orElse: () => throw Exception('Member not found'),
    );
    return WorkspaceMemberModel.fromJson(memberJson);
  }
  /// [Category] Methods

  @override
  Future<CategoryModel> createCategory(String workspaceId, String name) async {
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/',
      {'name': name},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return CategoryModel.fromJson(decodedJson);
  }

  @override
  Future<List<CategoryModel>> fetchCategories(String workspaceId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteCategory(String workspaceId, int categoryId) async {
    final response = await client.delete('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/', null);
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> addMemberToCategory(String workspaceId, int categoryId, String email) async {
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/members/',
      {'user_email': email},
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<CategoryModel> updateCategory(String workspaceId, int categoryId, String name) async {
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/',
      {'name': name},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return CategoryModel.fromJson(decodedJson);
  }

  @override
  Future<List<CategoryMemberModel>> getCategoryMembers(String workspaceId, int categoryId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/members/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => CategoryMemberModel.fromJson(e)).toList();
  }

  @override
  Future<void> removeMemberFromCategory(String workspaceId, int categoryId, String email) async {
    final response = await client.delete(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/members/$email/'
      , null
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<CategoryMemberModel> getCategoryMember(String workspaceId, int categoryId, String email) async {
    final response = await client.get(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/members/?email=$email',
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return CategoryMemberModel.fromJson(decodedJson);
  }

  @override
  Future<void> updateCategoryMember(String workspaceId, int categoryId, String email, String role) async {
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/members/$email/',
      {'role': role},
    );
    _handleResponse(response.statusCode);
  }

  /// [Channel] Methods
  @override
  Future<ChannelModel> createChannel(String workspaceId, int categoryId, String name, Assignment assignment) async {
    final tasks = assignment.tasks;
    final tasksList = tasks.map((task) {
      return {
        'task':task.title,
        'due_date': DateFormat('yyyy-MM-dd').format(task.dueDate),
      };
    }).toList();
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/',
      { 
        'name': name,
        'assignment_data': {
          'description': assignment.description,
          'for_teams': assignment.forTeams,
          'total_points': assignment.totalPoints,
          'tasks': tasksList,
        },
      },
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return ChannelModel.fromJson(decodedJson);
  }

  @override
  Future<ChannelModel> updateChannel(String workspaceId, int categoryId, String channelId, String? name, Assignment assignment) async {
    final tasks = assignment.tasks;
    final tasksList = tasks.map((task) {
      return {
        'task':task.title,
        'due_date': DateFormat('yyyy-MM-dd').format(task.dueDate),
      };
    }).toList();
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/',
       { 
        'name': name,
        'assignment_data': {
          'description': assignment.description,
          'for_teams': assignment.forTeams,
          'total_points': assignment.totalPoints,
          'tasks': tasksList,
        },
      },
    );
    
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return ChannelModel.fromJson(decodedJson);
  }

  @override
  Future<List<ChannelModel>> fetchChannels(String workspaceId, int categoryId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => ChannelModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteChannel(String workspaceId, int categoryId, String channelId) async {
    final response = await client.delete('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/', null);
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> addMemberToChannel(String workspaceId, int categoryId, String channelId, String email, String role) async {
    final response = await client.post(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/',
      {
        'user_email': email,
        'role': role
      },
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> removeMemberFromChannel(String workspaceId, int categoryId, String channelId, String email) async {
    final response = await client.delete(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/',
      {'user_email': email},
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> updateChannelMember(String workspaceId, int categoryId, String channelId, String email, String role) async {
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/',
      {
        'user_email': email, 
        'role': role
      },
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<List<ChannelMemberModel>> getChannelMembers(String workspaceId, int categoryId, String channelId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => ChannelMemberModel.fromJson(e)).toList();
  }

  @override
  Future<ChannelMemberModel> getChannelMember(String workspaceId, int categoryId, String channelId, String email) async {
    final Uri uri = Uri.parse(
    '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/')
    .replace(queryParameters: {'email': email});
    final response = await client.get(uri.toString());
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final Map<String, dynamic> memberJson = decodedJson.firstWhere(
      (element) => element['user']['email'] == email,
      orElse: () => throw Exception('Member not found'),
    );
    return ChannelMemberModel.fromJson(memberJson);
  }

  /// [Assignment] Methods

  @override
  Future<AssignmentModel> updateAssignment(String workspaceId, int categoryId, String channelId, Assignment assignment) async {
    final tasks = assignment.tasks;
    final tasksList = tasks.map((task) {
      return {
        'task':task.title,
        'due_date': DateFormat('yyyy-MM-dd').format(task.dueDate),
      };
    }).toList();
    final response = await client.put(
      '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/assignment/',
       {
          'description': assignment.description,
          'for_teams': assignment.forTeams,
          'total_points': assignment.totalPoints,
          'tasks': tasksList,
       },
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return AssignmentModel.fromJson(decodedJson);
  }

  @override
  Future<AssignmentModel> getAssignment(String workspaceId, int categoryId, String channelId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/assignment/');
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return AssignmentModel.fromJson(decodedJson);
  }

  /// [SubmissionReviewee] Methods

  @override
  Future<List<SubmissionModel>> getSubmissionReviewees(String workspaceId, int categoryId, String channelId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submission/reviewee/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => SubmissionModel.fromJson(e)).toList();
  }

  @override
  Future<List<SubmissionModel>> postSubmissionReviewee(String workspaceId, int categoryId, String channelId, String? content, String? file) async {
    final response = await client.post('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submission/reviewee/', 
    {
      'content': content,
      'file': file
    }); 
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => SubmissionModel.fromJson(e)).toList();
  }

  /// [SubmissionReviewer] Methods

  @override
  Future<List<SubmissionModel>> getSubmissionByUserId(String workspaceId, int categoryId, String channelId, String userId) async {
    final response = await client.get('${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submission/reviewers/$userId/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => SubmissionModel.fromJson(e)).toList();
  }

  /// [Iteration] Methods

  @override
  Future<ReviewIterationModel> createIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
    String remarks,
    AssignmentStatus? assignmentStatus,
  ) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submissions/$submissionId/reviewer-iterations/',
      jsonEncode({
        'remarks': remarks,
        'assignment_status': assignmentStatus != null
            ? {
                'status': assignmentStatus.status,
                'earned_points': assignmentStatus.earnedPoints,
              }
            : null,
      }),
    );
    _handleResponse(response.statusCode);
    return ReviewIterationModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ReviewIterationModel> getReviewerIteration(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  ) async {
    final response = await client.get(
        '${AppConstants.baseUrl}/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submissions/$submissionId/reviewer-iterations/',
    );
    _handleResponse(response.statusCode);
    return ReviewIterationModel.fromJson(json.decode(response.body));
  }

  @override
  Future<RevieweeIterationsResponseModel> getRevieweeIterations(
    String workspaceId,
    int categoryId,
    String channelId,
    String submissionId,
  ) async {
    final response = await client.get(
        '${AppConstants.baseUrl}workspaces/$workspaceId/categories/$categoryId/channels/$channelId/submissions/$submissionId/reviewee-iterations/',
    );
    _handleResponse(response.statusCode);
    return RevieweeIterationsResponseModel.fromJson(json.decode(response.body));
  } 
}
