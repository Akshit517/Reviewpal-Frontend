import 'package:equatable/equatable.dart';

class AssignmentStatus extends Equatable {
  final String status;
  final int earnedPoints;

  const AssignmentStatus({required this.status, required this.earnedPoints});

  @override
  List<Object> get props => [status, earnedPoints];
}