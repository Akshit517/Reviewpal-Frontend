import '../../../domain/entities/category_entity.dart';
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
    var channelsFromJson = json['channels'] as List;
    List<ChannelModel> channelsList =
        channelsFromJson.map((channelJson) => ChannelModel.fromJson(channelJson)).toList();

    return CategoryModel(
      id: json['id'],
      name: json['name'],
      workspace: json['workspace'],
      channels: channelsList,
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