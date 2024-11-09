import 'package:http/http.dart' as http;

abstract class WorkspaceRemoteDataSource {

}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final http.Client client;
  
  WorkspaceRemoteDataSourceImpl({required this.client});
  //yet to implement
}