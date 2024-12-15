import 'dart:convert';

import 'package:ReviewPal/core/constants/constants.dart';
import 'package:ReviewPal/core/network/token/token_http_client.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/workspaces/workspace.dart';

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
  
  Future<List<Map<String, dynamic>>> fetchWorkspaceMembers(String workspaceId);

  Future<void> addWorkspaceMember({
    required String workspaceId,
    required String userEmail,
    required String role,
  });

  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String userEmail,
  });
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final TokenHttpClient client;

  WorkspaceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<WorkspaceModel>> fetchWorkspaces() async {
    final response = await client.get('${AppConstants.baseUrl}/api/workspaces/');
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = jsonDecode(response.body);  
      final workspaces = decodedJson
        .map((element) => WorkspaceModel.fromJson(element))
        .toList();
      return workspaces;
    } else {
      throw ServerException();
    }
  }


  @override
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String icon,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/',
      {
        'name': name,
        'icon': icon,
      },
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      return WorkspaceModel.fromJson(decodedJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WorkspaceModel> getWorkspace({required String workspaceId}) async {
    final response = await client.get(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/',
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      return WorkspaceModel.fromJson(decodedJson);
    }else{
      throw ServerException();
    }
  }

  Future<WorkspaceModel> updateWorkspace({
    required String workspaceId,
    required String name,
    required String icon,
  }) async {
    final response = await client.put(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/',
      {
        'name': name,
        'icon': icon,
      },
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      return WorkspaceModel.fromJson(decodedJson);
    }else{
      throw ServerException();
    }
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    final response = await client.delete(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/',
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchWorkspaceMembers(String workspaceId) async {
    final response = await client.get(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/',
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.cast<Map<String, dynamic>>();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> addWorkspaceMember({
    required String workspaceId,
    required String userEmail,
    required String role,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/',
      {
        'user_email': userEmail,
        'role': role,
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeWorkspaceMember({
    required String workspaceId,
    required String userEmail,
  }) async {
    final response = await client.post(
      '${AppConstants.baseUrl}/api/workspaces/$workspaceId/members/delete/',
      {
        'user_email': userEmail,
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ServerException();
    }
  }
}