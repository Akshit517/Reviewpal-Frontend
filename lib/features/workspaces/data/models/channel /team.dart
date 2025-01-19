import '../../../domain/entities/channel/team.dart';

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['team_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
