part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
  
  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});
}

class CategoriesLoaded extends CategoryState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategorySuccess extends CategoryState {
  final String message;

  const CategorySuccess({required this.message});

  @override
  List<Object> get props => [message];
}
