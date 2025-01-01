import '../assignment/assignment_entity.dart';

class Channel {
  final String id;
  final String name;
  final Assignment? assignment;

  const Channel({
    required this.id,
    required this.name,
    this.assignment,
  });
}