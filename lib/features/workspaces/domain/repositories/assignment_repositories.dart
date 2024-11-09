import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/assignment_entity.dart';

abstract class AssignmentRepositories {

  Either<Failure, Assignment> getAssignment(String workspaceId, String categoryId, String channelId, String accessToken);

  Either<Failure, void> updateAssignment(String workspaceId, String categoryId, String channelId, String accessToken, Assignment assignment);
  // to implement add_task directly at backend
}