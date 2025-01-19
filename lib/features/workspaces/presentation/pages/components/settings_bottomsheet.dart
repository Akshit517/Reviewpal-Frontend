import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/routes/routes.dart';
import '../../../../../core/presentation/widgets/divider/bottomsheet_divider.dart';
import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';
import '../../blocs/workspace/member/workspace_member_bloc.dart';

class SettingsBottomsheet extends StatefulWidget {
  final Workspace workspace;
  const SettingsBottomsheet({super.key, required this.workspace});

  @override
  State<SettingsBottomsheet> createState() => _SettingsBottomsheetState();
}

class _SettingsBottomsheetState extends State<SettingsBottomsheet> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final singleWorkspaceMemberState =
        context.watch<SingleWorkspaceMemberCubit>().state;
    return Wrap(
      children: [
        const BottomSheetDivider(),
        if (singleWorkspaceMemberState.isSuccess == true &&
            singleWorkspaceMemberState.isLoading == false &&
            singleWorkspaceMemberState.member!.role == "workspace_admin")
          _buildAddWorkspaceMemberTile(context),
        ListTile(
          leading: const Icon(Icons.group_rounded),
          title: const Text('View Workspace Members'),
          onTap: () {
            Navigator.pop(context);
            context.push(CustomNavigationHelper.workspaceMembersPath,
                extra: {"workspace": widget.workspace});
          },
        ),
      ],
    );
  }

  ListTile _buildAddWorkspaceMemberTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_add_alt_1_rounded),
      title: const Text('Add Workspace Member'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Add Workspace Member'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldWidget(
                  controller: controller,
                  hintText: 'Enter user email to invite...',
                  haveObscureText: false,
                  haveSuffixIconObscure: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormFieldWidget(
                  controller: _roleController,
                  hintText: 'Enter user role...',
                  haveObscureText: false,
                  haveSuffixIconObscure: false,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<WorkspaceMemberBloc>().add(
                          AddWorkspaceMemberEvent(
                            workspaceId: widget.workspace.id,
                            email: controller.text.trim(),
                            role: _roleController.text.trim(),
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          ),
        );
        Navigator.pop(context);
      },
    );
  }
}
