import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';

class DoubtScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  const DoubtScreen(
      {super.key,
      required this.workspace,
      required this.category,
      required this.channel});

  @override
  State<DoubtScreen> createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Group Chats",
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
      ),
      body: const Center(
        child: Text("Doubt Screen"),
      ),
    );
  }
}
