import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../../core/presentation/widgets/text_field/text_field_header.dart';
import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../../../injection.dart';
import '../../blocs/workspace/workspace_bloc/workspace_bloc.dart';
import 'package:ReviewPal/core/infrastructure/media/media_uploader.dart';

class AddWorkspaceDialog extends StatefulWidget {
  const AddWorkspaceDialog({super.key});

  @override
  State<AddWorkspaceDialog> createState() => _AddWorkspaceDialogState();
}

class _AddWorkspaceDialogState extends State<AddWorkspaceDialog> {
  final _workspaceNameTextController = TextEditingController();
  final _workspaceIconTextController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _clearControllers();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DarkThemePalette.fillColor,
                      ),
                      onPressed: _pickImage,
                      child: const Text('Select Icon'),
                    ),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          _selectedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
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
                      onPressed: () async =>
                          _uploadImageAndCreateWorkspace(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImageAndCreateWorkspace(BuildContext context) async {
    if (_selectedImage == null || _workspaceNameTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the required fields!!!')),
      );
      return;
    }
    try {
      final uploadedUrl = await sl<MediaUploader>().uploadMedia(
        image: _selectedImage!,
      );
      if (!context.mounted) return;
      final workspaceBloc = context.read<WorkspaceBloc>();
      final completer = Completer<void>();
      late StreamSubscription subscription;
      subscription = workspaceBloc.stream.listen((state) {
        if (state is WorkspaceCreated || state is WorkspaceError) {
          if (state is WorkspaceError) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is WorkspaceCreated) {
            workspaceBloc.add(const GetJoinedWorkspacesEvent());
            _clearControllers();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
          subscription.cancel();
          completer.complete();
        }
      });
      workspaceBloc.add(
        CreateWorkspaceEvent(
          name: _workspaceNameTextController.text.trim(),
          icon: uploadedUrl,
        ),
      );
      await completer.future;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  void _clearControllers() {
    _workspaceNameTextController.clear();
    _workspaceIconTextController.clear();
    setState(() {
      _selectedImage = null;
    });
  }
}
