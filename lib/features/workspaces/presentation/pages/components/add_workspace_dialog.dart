import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/text_field/text_field_header.dart';
import '../../../../../core/widgets/text_field/text_form_field.dart';
import '../../blocs/workspace/workspace_bloc.dart';

class AddWorkspaceDialog extends StatefulWidget {
  const AddWorkspaceDialog({super.key});

  @override
  State<AddWorkspaceDialog> createState() => _AddWorkspaceDialogState();
}

class _AddWorkspaceDialogState extends State<AddWorkspaceDialog> {
  final _workspaceNameTextController = TextEditingController();
  final _workspaceIconTextController = TextEditingController();

  @override
  void dispose() {
    _workspaceNameTextController.dispose();
    _workspaceIconTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextFieldHeader(
              text: 'ADD WORKSPACE',
            ),
            const SizedBox(height: 8.0),
            TextFormFieldWidget(
              hintText: "Workspace Name",
              controller: _workspaceNameTextController,
              haveObscureText: false,
              haveSuffixIconObscure: false,
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              hintText: "Workspace Icon",
              controller: _workspaceIconTextController,
              haveObscureText: false,
              haveSuffixIconObscure: false,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    _clearControllers(); 
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    context.read<WorkspaceBloc>().add(
                          CreateWorkspaceEvent(
                            name: _workspaceNameTextController.text.trim(),
                            icon: _workspaceIconTextController.text.trim(),
                          ),
                        );
                    _clearControllers(); 
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearControllers() {
    _workspaceNameTextController.clear();
    _workspaceIconTextController.clear();
  }
}
