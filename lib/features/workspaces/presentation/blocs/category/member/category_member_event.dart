part of 'category_member_bloc.dart';

sealed class CategoryMemberEvent extends Equatable {
  const CategoryMemberEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryMembersEvent extends CategoryMemberEvent {
  final String workspaceId;
  final int categoryId;

  const GetCategoryMembersEvent({
    required this.workspaceId,
    required this.categoryId,
  });
}

class AddCategoryMemberEvent extends CategoryMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String userEmail;

  const AddCategoryMemberEvent({
    required this.userEmail,
    required this.workspaceId,
    required this.categoryId,
  });
}

class RemoveCategoryMemberEvent extends CategoryMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String userEmail;

  const RemoveCategoryMemberEvent({
    required this.userEmail,
    required this.workspaceId,
    required this.categoryId,
  });
}
