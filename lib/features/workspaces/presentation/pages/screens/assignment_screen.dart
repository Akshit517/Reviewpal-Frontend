import 'package:flutter/material.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';

class AssignmentScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  const AssignmentScreen({super.key, required this.workspace, required this.category, required this.channel});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name),
      ),
      body: SafeArea(
        child: InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.assignment_outlined,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                "Assignment 1",
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ))
    );
  }
}