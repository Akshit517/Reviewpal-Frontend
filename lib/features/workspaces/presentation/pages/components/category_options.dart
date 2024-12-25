
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/divider/bottomsheet_divider.dart';
import '../../../../../core/widgets/text_field/text_form_field.dart';
import '../../blocs/category/category_bloc.dart';
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
    final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final List<TaskController> _taskControllers = [];
  bool _forTeams = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    for (var controller in _taskControllers) {
      controller.titleController.dispose();
    }
    super.dispose();
  }
  void _addNewTask() {
    setState(() {
      _taskControllers.add(
        TaskController(
          titleController: TextEditingController(),
          dueDate: null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const BottomSheetDivider(),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text("Delete Category"),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Delete Category"),
                content: const Text("Are you sure you want to delete this category?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      context.read<CategoryBloc>().add(DeleteCategoryEvent(
                        workspaceId: widget.widget.workspace.id,
                        categoryId: widget.widget.category.id,
                      ));
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );
          },
        ),
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
      ],
    );
  }
}


class TaskInputWidget extends StatelessWidget {
  final TextEditingController titleController;
  final DateTime? dueDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onDelete;

  const TaskInputWidget({
    required this.titleController,
    required this.dueDate,
    required this.onDateSelected,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            hintText: "Task title",
            controller: titleController,
            haveObscureText: false,
            haveSuffixIconObscure: false,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class TaskController {
  final TextEditingController titleController;
  DateTime? dueDate;

  TaskController({
    required this.titleController,
    this.dueDate,
  });
}