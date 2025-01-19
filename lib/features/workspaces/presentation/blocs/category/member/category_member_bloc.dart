import 'package:ReviewPal/features/workspaces/domain/usecases/category/category_member.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/category/category_member.dart';

part 'category_member_event.dart';
part 'category_member_state.dart';

class CategoryMemberBloc
    extends Bloc<CategoryMemberEvent, CategoryMemberState> {
  final AddCategoryMemberUseCase addCategoryMemberUseCase;
  final GetCategoryMembersUseCase getCategoryMembersUseCase;
  final DeleteCategoryMemberUseCase deleteCategoryMemberUseCase;

  CategoryMemberBloc(
      {required this.addCategoryMemberUseCase,
      required this.getCategoryMembersUseCase,
      required this.deleteCategoryMemberUseCase})
      : super(CategoryMemberInitial()) {
    on<GetCategoryMembersEvent>(_getCategoryMembers);
    on<AddCategoryMemberEvent>(_addCategoryMember);
    on<RemoveCategoryMemberEvent>(_deleteCategoryMember);
  }

  void _getCategoryMembers(
      GetCategoryMembersEvent event, Emitter<CategoryMemberState> emit) async {
    emit(CategoryMemberLoading());
    final result = await getCategoryMembersUseCase(CategoryMemberParams(
      workspaceId: event.workspaceId,
      categoryId: event.categoryId,
    ));
    result.fold(
        (failure) => emit(CategoryMemberError(message: failure.message)),
        (members) => emit(CategoryMemberSuccess(members: members)));
  }

  void _addCategoryMember(
      AddCategoryMemberEvent event, Emitter<CategoryMemberState> emit) async {
    emit(CategoryMemberLoading());
    final result = await addCategoryMemberUseCase(CategoryMemberParams(
      workspaceId: event.workspaceId,
      categoryId: event.categoryId,
      email: event.userEmail,
    ));
    result.fold(
        (failure) => emit(CategoryMemberError(message: failure.message)),
        (message) => emit(const CategoryMemberSuccess()));
  }

  void _deleteCategoryMember(RemoveCategoryMemberEvent event,
      Emitter<CategoryMemberState> emit) async {
    emit(CategoryMemberLoading());
    final result = await deleteCategoryMemberUseCase(CategoryMemberParams(
        workspaceId: event.workspaceId,
        categoryId: event.categoryId,
        email: event.userEmail));
    result.fold(
        (failure) => emit(CategoryMemberError(message: failure.message)),
        (message) => emit(const CategoryMemberSuccess()));
  }
}
