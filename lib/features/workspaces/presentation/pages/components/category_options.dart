import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/routes/routes.dart';
import '../../../../../core/presentation/widgets/divider/bottomsheet_divider.dart';
import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../blocs/category/category_bloc/category_bloc.dart';
import '../../blocs/category/member/category_member_bloc.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';
import 'category_expansion_tile.dart';

class CategoryOptions extends StatefulWidget {
  const CategoryOptions({
    super.key,
    required this.widget,
  });

  final CategoryExpansionTile widget;

  @override
  State<CategoryOptions> createState() => _CategoryOptionsState();
}

class _CategoryOptionsState extends State<CategoryOptions> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final workspaceMemberState =
        context.watch<SingleWorkspaceMemberCubit>().state;
    return Wrap(
      children: [
        const BottomSheetDivider(),
        if (workspaceMemberState.member!.role == "workspace_admin")
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Category"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Category"),
                  content: const Text(
                      "Are you sure you want to delete this category?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CategoryBloc>().add(DeleteCategoryEvent(
                              workspaceId: widget.widget.workspace.id,
                              categoryId: widget.widget.category.id,
                            ));
                        Navigator.pop(context);
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
        if (workspaceMemberState.member!.role == "workspace_admin")
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Edit Category"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Edit Category"),
                  content: TextFormFieldWidget(
                    hintText: "Enter category",
                    controller: _nameController,
                    haveObscureText: false,
                    haveSuffixIconObscure: false,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CategoryBloc>().add(UpdateCategoryEvent(
                              workspaceId: widget.widget.workspace.id,
                              categoryId: widget.widget.category.id,
                              name: _nameController.text.trim(),
                            ));
                        Navigator.pop(context);
                      },
                      child: const Text("Update"),
                    ),
                  ],
                ),
              );
            },
          ),
        ListTile(
          leading: const Icon(Icons.group_rounded),
          title: const Text("View Category Members"),
          onTap: () {
            context.read<CategoryMemberBloc>().add(GetCategoryMembersEvent(
                  workspaceId: widget.widget.workspace.id,
                  categoryId: widget.widget.category.id,
                ));
            context.push(CustomNavigationHelper.categoryMembersPath, extra: {
              'workspace': widget.widget.workspace,
              'category': widget.widget.category,
            });
            Navigator.pop(context);
          },
        ),
        if (workspaceMemberState.member!.role == "workspace_admin")
          ListTile(
            leading: const Icon(Icons.add, color: Colors.green),
            title: const Text("Add Assignment"),
            onTap: () {
              context
                  .push(CustomNavigationHelper.addAssignmentScreenPath, extra: {
                'workspace': widget.widget.workspace,
                'category': widget.widget.category,
                'forUpdateAssignment': false,
                'channel': null
              });
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
