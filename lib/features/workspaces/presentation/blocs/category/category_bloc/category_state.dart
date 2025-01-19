// ignore_for_file: must_be_immutable

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
