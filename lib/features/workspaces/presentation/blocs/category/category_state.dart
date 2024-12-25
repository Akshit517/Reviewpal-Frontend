part of 'category_bloc.dart';

class CategoryState extends Equatable {
  List<Category> categories;
  bool isLoading;
  bool isSuccess;
  String message;
  CategoryState({
    this.categories = const [],
    this.isLoading = true,
    this.isSuccess = false,
    this.message = '', 
  });
  
  @override
  List<Object> get props => [categories, isLoading, isSuccess, message];

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }
}

// final class CategoryInitial extends CategoryState {}

// final class CategoryLoading extends CategoryState {}

// final class CategoryError extends CategoryState {
//   final String message;

//   const CategoryError({required this.message});
// }

// class CategoriesLoaded extends CategoryState {
//   final List<Category> categories;

//   const CategoriesLoaded(this.categories);

//   @override
//   List<Object> get props => [categories];
// }

// class CategorySuccess extends CategoryState {
//   final String message;

//   const CategorySuccess({required this.message});

//   @override
//   List<Object> get props => [message];
// }
