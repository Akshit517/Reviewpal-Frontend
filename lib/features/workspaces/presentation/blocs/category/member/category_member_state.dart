part of 'category_member_bloc.dart';

sealed class CategoryMemberState extends Equatable {
  const CategoryMemberState();

  @override
  List<Object> get props => [];
}

final class CategoryMemberInitial extends CategoryMemberState {}

final class CategoryMemberLoading extends CategoryMemberState {}

final class CategoryMemberError extends CategoryMemberState {
  final String message;
  const CategoryMemberError({required this.message});
}

final class CategoryMemberSuccess extends CategoryMemberState {
  final List<CategoryMember>? members;
  const CategoryMemberSuccess({this.members});
}
