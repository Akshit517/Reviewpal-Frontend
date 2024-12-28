import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/media/media_uploader.dart';
import '../../../../injection.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../blocs/submission/submission_bloc.dart';

class CreateSubmissionDialog extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const CreateSubmissionDialog({
    super.key,
    required this.workspace,
    required this.category,
    required this.channel,
  });

  @override
  State<CreateSubmissionDialog> createState() => _CreateSubmissionDialogState();
}

class _CreateSubmissionDialogState extends State<CreateSubmissionDialog> {
  final _contentController = TextEditingController();
  File? _selectedFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter content')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? fileUrl;
      if (_selectedFile != null) {
        final mediaUploader = sl<MediaUploader>();
        fileUrl = await mediaUploader.uploadMedia(image: _selectedFile!);
      }

      context.read<SubmissionBloc>().add(
        CreateSubmissionEvent(
          workspaceId: widget.workspace.id,
          categoryId: widget.category.id,
          channelId: widget.channel.id,
          content: _contentController.text,
          file: fileUrl,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Submission'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter content here....',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Select File'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFile?.path.split('/').last ?? 'No file selected',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}