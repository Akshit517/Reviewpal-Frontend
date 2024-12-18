import 'dart:convert';

import 'package:ReviewPal/core/constants/constants.dart';
import 'package:ReviewPal/core/network/token/token_http_client.dart';
import 'package:ReviewPal/features/workspaces/data/models/workspaces/members.dart';

import '../../../../core/error/exceptions.dart';
import '../models/category/category.dart';
import '../models/channel /channel.dart';
import '../models/workspaces/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<WorkspaceModel>> fetchWorkspaces();
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String icon,
  });
  Future<WorkspaceModel> getWorkspace({required String workspaceId});
  Future<WorkspaceModel> updateWorkspace({
    required String workspaceId,
    required String name,
    required String icon,
  });
  Future<void> deleteWorkspace(String workspaceId);

  Future<List<WorkspaceMemberModel>> fetchWorkspaceMembers(String workspaceId);
  Future<void> addWorkspaceMember({
    required String workspaceId,
    required String userEmail,
    required String role,
  });
  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String userEmail,
  });

  // Category methods
  Future<CategoryModel> createCategory(String workspaceId, String name);
  Future<List<CategoryModel>> fetchCategories(String workspaceId);
  Future<void> deleteCategory(String workspaceId, String categoryId);
  Future<void> addMemberToCategory(String workspaceId, String categoryId, String email);

  // Channel methods
  Future<ChannelModel> createChannel(String workspaceId, String categoryId, String name);
  Future<List<ChannelModel>> fetchChannels(String workspaceId, String categoryId);
  Future<void> deleteChannel(String workspaceId, String categoryId, String channelId);
  Future<void> addMemberToChannel(String workspaceId, String categoryId, String channelId, String email);
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

  @override
  Future<List<WorkspaceModel>> fetchWorkspaces() async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/');
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
      '${AppConstants.baseUrl}/api/workspaces/',
      {'name': name, 'icon': icon},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return WorkspaceModel.fromJson(decodedJson);
  }

  @override
  Future<WorkspaceModel> getWorkspace({required String workspaceId}) async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/$workspaceId/');
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
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/',
      {'name': name, 'icon': icon},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return WorkspaceModel.fromJson(decodedJson);
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    final response = await client.delete('${AppConstants.baseUrl}/api/workspaces/$workspaceId/');
    _handleResponse(response.statusCode);
  }

  @override
  Future<List<WorkspaceMemberModel>> fetchWorkspaceMembers(String workspaceId) async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => WorkspaceMemberModel.fromJson(e)).toList();
  }

  @override
  Future<void> addWorkspaceMember({
    required String workspaceId,
    required String userEmail,
    required String role,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/',
      {'user_email': userEmail, 'role': role},
    );
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String userEmail,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/delete/',
      {'user_email': userEmail},
    );
    _handleResponse(response.statusCode);
  }

  // Category Methods

  @override
  Future<CategoryModel> createCategory(String workspaceId, String name) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/',
      {'name': name},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return CategoryModel.fromJson(decodedJson);
  }

  @override
  Future<List<CategoryModel>> fetchCategories(String workspaceId) async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteCategory(String workspaceId, String categoryId) async {
    final response = await client.delete('${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/');
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> addMemberToCategory(String workspaceId, String categoryId, String email) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/members/',
      {'user_email': email},
    );
    _handleResponse(response.statusCode);
  }

  // Channel Methods

  @override
  Future<ChannelModel> createChannel(String workspaceId, String categoryId, String name) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/channels/',
      {'name': name},
    );
    _handleResponse(response.statusCode);
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return ChannelModel.fromJson(decodedJson);
  }

  @override
  Future<List<ChannelModel>> fetchChannels(String workspaceId, String categoryId) async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/channels/');
    _handleResponse(response.statusCode);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => ChannelModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteChannel(String workspaceId, String categoryId, String channelId) async {
    final response = await client.delete('${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/');
    _handleResponse(response.statusCode);
  }

  @override
  Future<void> addMemberToChannel(String workspaceId, String categoryId, String channelId, String email) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/members/',
      {'user_email': email},
    );
    _handleResponse(response.statusCode);
  }
}
