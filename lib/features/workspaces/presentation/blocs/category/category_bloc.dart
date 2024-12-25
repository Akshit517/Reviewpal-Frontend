import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/category/create_category.dart';
import '../../../domain/usecases/category/delete_category.dart';
import '../../../domain/usecases/category/get_categories.dart';
import '../../../domain/usecases/category/update_category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategory deleteCategoryUseCase;
  final CreateCategory createCategory;

  CategoryBloc({
    required this.getCategories,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
    required this.createCategory
  }) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
  }

  Future<void> _onGetCategories(
      GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getCategories(event.workspaceId);
    result.fold(
      (failure) => emit(CategoryError(message: _mapFailureToMessage(failure))),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await updateCategoryUseCase(event.workspaceId, event.categoryId, event.name);
    result.fold(
      (failure) => emit(CategoryError(message: _mapFailureToMessage(failure))),
      (_) => emit(const CategorySuccess(message: "Category Updated")),
    );
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await deleteCategoryUseCase(event.workspaceId, event.categoryId);
    result.fold(
      (failure) => emit(CategoryError(message: _mapFailureToMessage(failure))),
      (_) => emit(const CategorySuccess(message: 'Category Deleted')),
    );
  }

  Future<void> _onCreateCategory(
      CreateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await createCategory(event.workspaceId, event.name);
    result.fold(
      (failure) => emit(CategoryError(message: _mapFailureToMessage(failure))),
      (_) => emit(const CategorySuccess(message: 'Category Created')),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is UnauthorizedFailure) {
      return 'Unauthorized Access';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else {
      return 'Unexpected Error';
    }
  }
}
