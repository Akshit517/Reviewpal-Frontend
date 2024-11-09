import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class WorkspaceLocalDataSource {

}

class WorkspaceLocalDataSourceImpl implements WorkspaceLocalDataSource {
  final FlutterSecureStorage secureStorage;

  WorkspaceLocalDataSourceImpl({required this.secureStorage});
}

//yet to implement