import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../blocs/category/category_bloc.dart';

class CreateCategoryDialog extends StatefulWidget {
  final String workspaceId;
  final BuildContext ctx;

  const CreateCategoryDialog({
    super.key,
    required this.workspaceId,
    required this.ctx,
  });

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AlertDialog(
            content: TextFormFieldWidget(
          hintText: "Enter category",
          controller: _nameController,
          haveObscureText: false,
          haveSuffixIconObscure: false,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(widget.ctx).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<CategoryBloc>().add(CreateCategoryEvent(
                      workspaceId: widget.workspaceId,
                      name: _nameController.text.trim(),
                    ));
                Navigator.of(widget.ctx).pop();
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
