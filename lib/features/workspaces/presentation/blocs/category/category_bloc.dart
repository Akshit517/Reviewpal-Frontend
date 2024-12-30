import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/category/category_entity.dart';
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
    required this.createCategory,
  }) : super(CategoryState()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
  }

  Future<void> _onGetCategories(
      GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result = await getCategories(event.workspaceId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: _mapFailureToMessage(failure),
      )),
      (categories) => emit(state.copyWith(
        categories: categories,
        isLoading: false,
        isSuccess: true,
      )),
    );
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result = await updateCategoryUseCase(
      event.workspaceId,
      event.categoryId,
      event.name,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: _mapFailureToMessage(failure),
      )),
      (updatedCategory) => emit(state.copyWith(
        categories: state.categories
            .map((category) =>
                (category.id == updatedCategory.id) ? updatedCategory : category).toList(),
        isLoading: false,
        isSuccess: true,
        message: 'Category Updated',
      )),
    );
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result = await deleteCategoryUseCase(event.workspaceId, event.categoryId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: _mapFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        categories: state.categories
            .where((category) => category.id != event.categoryId)
            .toList(),
        isLoading: false,
        isSuccess: true,
        message: 'Category Deleted',
      )),
    );
  }

  Future<void> _onCreateCategory(
      CreateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result = await createCategory(event.workspaceId, event.name);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: _mapFailureToMessage(failure),
      )),
      (newCategory) => emit(state.copyWith(
        categories: [...state.categories, newCategory],
        isLoading: false,
        isSuccess: true,
        message: 'Category Created',
      )),
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
