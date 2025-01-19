part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {
  final String workspaceId;

  const GetCategoriesEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

class CreateCategoryEvent extends CategoryEvent {
  final String workspaceId;
  final String name;

  const CreateCategoryEvent({required this.workspaceId, required this.name});

  @override
  List<Object> get props => [workspaceId, name];
}

class UpdateCategoryEvent extends CategoryEvent {
  final String workspaceId;
  final int categoryId;
  final String name;

  const UpdateCategoryEvent(
      {required this.workspaceId,
      required this.categoryId,
      required this.name});

  @override
  List<Object> get props => [workspaceId, categoryId, name];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String workspaceId;
  final int categoryId;

  const DeleteCategoryEvent(
      {required this.workspaceId, required this.categoryId});

  @override
  List<Object> get props => [workspaceId, categoryId];
}
