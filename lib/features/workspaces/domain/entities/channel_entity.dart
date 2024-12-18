import 'assignment_entity.dart';

class Channel {
  final String name;
  final Assignment? assignment;

  const Channel({
    required this.name,
    this.assignment,
  });
}