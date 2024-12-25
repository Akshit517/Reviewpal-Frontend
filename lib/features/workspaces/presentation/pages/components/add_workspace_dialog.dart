import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../../core/widgets/text_field/text_field_header.dart';
import '../../../../../core/widgets/text_field/text_form_field.dart';
import '../../../../injection.dart';
import '../../blocs/workspace/workspace_bloc.dart';
import 'package:ReviewPal/core/network/media/media_uploader.dart';

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
    _workspaceNameTextController.dispose();
    _workspaceIconTextController.dispose();
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

  Future<void> _uploadImageAndCreateWorkspace(BuildContext context) async {
    if (_selectedImage != null  && _workspaceNameTextController.text.isNotEmpty) {
      try {
        final uploadedUrl = await sl<MediaUploader>().uploadMedia(
          image: _selectedImage!,
        );
        if (context.mounted) {
          context.read<WorkspaceBloc>().add(
              CreateWorkspaceEvent(
                name: _workspaceNameTextController.text.trim(),
                icon: uploadedUrl,
              ),
            );
          context.read<WorkspaceBloc>().add(const GetJoinedWorkspacesEvent());  
          _clearControllers();
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the required fields!!!')),
      );
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
                      onPressed: () async => _uploadImageAndCreateWorkspace(context),
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

  void _clearControllers() {
    _workspaceNameTextController.clear();
    _workspaceIconTextController.clear();
    setState(() {
      _selectedImage = null;
    });
  }
}
