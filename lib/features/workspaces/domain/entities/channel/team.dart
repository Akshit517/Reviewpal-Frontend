import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;

  const Team({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
