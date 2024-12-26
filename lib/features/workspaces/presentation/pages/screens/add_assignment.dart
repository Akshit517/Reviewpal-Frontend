import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/text_field/text_form_field.dart';
import '../../../domain/entities/assignment_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/channel/channel_bloc/channel_bloc.dart';

class AddUpdateAssignmentWidget extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel? channel;
  final bool forUpdateAssignment;

  const AddUpdateAssignmentWidget(
      {super.key,
      required this.workspace,
      required this.category,
      this.channel,
      required this.forUpdateAssignment});

  @override
  State<AddUpdateAssignmentWidget> createState() => _AddAssignmentWidgetState();
}

class _AddAssignmentWidgetState extends State<AddUpdateAssignmentWidget> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalPointsController = TextEditingController();
  final List<TaskRow> _tasks = [];

  @override
  void initState() {
    if (widget.forUpdateAssignment) {
      _nameController.text = widget.channel!.name;
      _descriptionController.text = widget.channel!.assignment!.description;
       _totalPointsController.text = widget.channel!.assignment!.totalPoints.toString();
      for (var task in widget.channel!.assignment!.tasks) {
        _tasks.add(TaskRow(
          onDelete: () => _removeTask(_tasks.length - 1),
          initialTask: task,
        ));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle =
        widget.forUpdateAssignment ? "Update Assignment" : "Add Assignment";
    return Scaffold(
      appBar: _buildAppBar(appBarTitle),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 640;
          final contentWidth =
              isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isTablet) const Spacer(flex: 1),
                Container(
                  width: contentWidth,
                  padding: const EdgeInsets.all(15.0),
                  child: _buildPageContent(constraints),
                ),
                if (isTablet) const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          height: 1.0,
          thickness: 3.0,
          color: Colors.grey,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPageContent(BoxConstraints constraints) {
    final isTablet = constraints.maxWidth >= 600;
    final buttonWidth =
        isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth * 0.9;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<ChannelBloc, ChannelState>(
          listener: (context, state) {
            if (state.isSuccess == false) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message!)));
            } else if (state.isSuccess == true) {
              context.pop();
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormFieldWidget(
                  controller: _nameController,
                  hintText: 'Enter title...',
                  haveObscureText: false,
                  haveSuffixIconObscure: false,
                ),
                const SizedBox(height: 8.0),
                TextFormFieldWidget(
                  controller: _descriptionController,
                  hintText: 'Enter description...',
                  haveObscureText: false,
                  haveSuffixIconObscure: false,
                ),
                const SizedBox(height: 8.0),
                TextFormFieldWidget(
                  controller: _totalPointsController,
                  hintText: 'Enter Points...',
                  haveObscureText: false,
                  haveSuffixIconObscure: false,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                ..._tasks,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _addNewTask,
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () {
                      final tasks =
                          _tasks.map((taskRow) => taskRow.getTask()).toList();
                      if (widget.forUpdateAssignment) {
                        context.read<ChannelBloc>().add(UpdateChannelEvent(
                            workspaceId: widget.workspace.id,
                            categoryId: widget.category.id,
                            channelId: widget.channel!.id,
                            name: _nameController.text.trim(),
                            assignment: Assignment(
                              description: _descriptionController.text.trim(),
                              forTeams: false,
                              totalPoints: int.tryParse(
                                      _totalPointsController.text.trim()) ??
                                  0,
                              tasks: tasks,
                            )));
                      } else {
                        context.read<ChannelBloc>().add(CreateChannelEvent(
                            workspaceId: widget.workspace.id,
                            categoryId: widget.category.id,
                            name: _nameController.text.trim(),
                            assignment: Assignment(
                              description: _descriptionController.text.trim(),
                              forTeams: false,
                              totalPoints: int.tryParse(
                                      _totalPointsController.text.trim()) ??
                                  0,
                              tasks: tasks,
                            )));
                      }
                    },
                    child: Text(
                      widget.forUpdateAssignment
                          ? 'Update Assignment'
                          : 'Add Assignment',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _addNewTask() {
    setState(() {
      _tasks.add(TaskRow(
        onDelete: () => _removeTask(_tasks.length - 1),
      ));
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }
}

class TaskRow extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final VoidCallback onDelete;

  TaskRow({super.key, required this.onDelete, Task? initialTask}) {
    if (initialTask != null) {
      _taskController.text = initialTask.title;
      _dateController.text =
          initialTask.dueDate.toIso8601String().split('T')[0];
    }
  }
  Task getTask() {
    return Task(
      title: _taskController.text.trim(),
      dueDate: DateTime.tryParse(_dateController.text.trim()) ?? DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormFieldWidget(
              controller: _taskController,
              hintText: 'Enter task...',
              haveObscureText: false,
              haveSuffixIconObscure: false,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormFieldWidget(
              controller: _dateController,
              hintText: 'Due date...',
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
                _dateController.text = date.toIso8601String().split('T')[0];
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
