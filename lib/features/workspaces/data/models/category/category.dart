import '../../../domain/entities/category/category_entity.dart';
import '../channel /channel.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.workspace,
    required List<ChannelModel> super.channels,
  });

  // From JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      workspace: json['workspace'],
      channels: (json['channels'] as List<dynamic>?)
              ?.map((channelJson) => ChannelModel.fromJson(channelJson))
              .toList() ?? [],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'workspace': workspace,
      'channels': channels.map((channel) => (channel as ChannelModel).toJson()).toList(),
    };
  }
}